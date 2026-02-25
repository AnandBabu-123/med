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

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.selectedLanguage,
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
      bottomNavigationBar:
      BlocConsumer<OtpBloc, OtpState>(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {

          return Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 50,
              child:
              ElevatedButton(
                onPressed: state.status == OtpStatus.loading
                    ? null
                    : () {

                  String otp =
                  controllers.map((e) => e.text).join();

                  if (otp.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter OTP")),
                    );
                    return;
                  }

                  /// ✅ CORRECT EVENT CALL
                  context.read<OtpBloc>().add(
                    VerifyOtpEvent(
                      mobile: widget.mobileNumber,
                      otp: otp,
                    ),
                  );
                },

                child: state.status ==
                    OtpStatus.loading
                    ? const CircularProgressIndicator(
                    color: Colors.white)
                    : Text(continueText),
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
