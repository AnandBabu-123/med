import 'package:flutter/material.dart';

import 'dart:async';
import '../../../bloc/otp_bloc/otp_bloc.dart';
import '../../../bloc/otp_bloc/otp_event.dart';
import '../../../bloc/otp_bloc/otp_state.dart';
import '../../../config/colors/app_colors.dart';
import '../../../config/language/app_strings.dart';
import '../../dashboard/dashboard_screens.dart';
import '../../dashboard_screen/dashboard_screen.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String selectedLanguage;
  final String apiOtp;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.selectedLanguage,
    required this.apiOtp,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  int seconds = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    seconds = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final continueText =
    AppStrings.get(widget.selectedLanguage, "continue");

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
      ),

      /// ✅ LISTEN API RESULT
      bottomNavigationBar: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {

          if (state.status == OtpStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardScreens(),
              ),
            );
          }

          if (state.status == OtpStatus.failure) {
            _showSnack(context, state.message);
          }
        },

        builder: (context, state) {

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: Colors.white,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.status == OtpStatus.loading
                    ? null
                    : () {

                  /// ENTERED OTP
                  String enteredOtp =
                  controllers.map((e) => e.text).join();

                  if (enteredOtp.length < 4) {
                    _showSnack(context, "Enter OTP");
                    return;
                  }

                  /// ✅ FRONTEND OTP MATCH
                  if (enteredOtp != widget.apiOtp) {
                    _showSnack(context, "Invalid OTP");
                    return;
                  }

                  /// ✅ CALL VERIFY API
                  context.read<OtpBloc>().add(
                    VerifyOtpEvent(
                      mobile: widget.mobileNumber,
                      otp: enteredOtp,
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // ✅ BLUE BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: state.status == OtpStatus.loading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),


      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 40),

            Image.asset(
              "assets/logo.png",
              height: 150,
            ),

            const SizedBox(height: 30),

            Text(
              "Enter OTP sent to ${widget.mobileNumber}",
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children:
              List.generate(4, (i) => _otpBox(i)),
            ),

            const SizedBox(height: 25),

            Text("00:${seconds.toString().padLeft(2, '0')}"),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        content: Text(message),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 55,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
