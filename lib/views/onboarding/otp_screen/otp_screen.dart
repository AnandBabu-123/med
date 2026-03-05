import 'package:flutter/material.dart';
import 'package:medryder/config/colors/app_colors.dart';
import 'dart:async';
import '../../../bloc/otp_bloc/otp_bloc.dart';
import '../../../bloc/otp_bloc/otp_event.dart';
import '../../../bloc/otp_bloc/otp_state.dart';
import '../../../config/routes/routes_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';


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

  int seconds = 40;
  Timer? timer;

  /// store latest otp
  late String currentOtp;

  @override
  void initState() {
    super.initState();

    /// first otp from login api
    currentOtp = widget.apiOtp;

    startTimer();
  }

  /// ================= TIMER =================
  void startTimer() {
    timer?.cancel();

    setState(() {
      seconds = 40;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  /// ================= RESEND OTP =================
  Future<void> resendOtp() async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "https://medconnect.org.in/bharosa/app/ws/resend_otp",
        data: {
          "mobile": widget.mobileNumber,
        },
      );

      // print("RESEND RESPONSE ${response.data}");

      if (response.data["status"] == true) {

        ///  correct path
        currentOtp = response.data["response"]["otp"].toString();

        // print("NEW OTP $currentOtp");

        _showSnack("OTP Resent Successfully");

        /// clear old boxes
        for (var c in controllers) {
          c.clear();
        }

        /// restart timer
        startTimer();

      } else {
        _showSnack(response.data["message"] ?? "Failed");
      }

    } catch (e) {
      _showSnack("Something went wrong");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
      ),

      /// ================= CONTINUE BUTTON =================
      bottomNavigationBar: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {

          if (state.status == OtpStatus.success) {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.dashBoardScreens,
            );
          }

          if (state.status == OtpStatus.failure) {
            _showSnack(state.message);
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

                  String enteredOtp =
                  controllers.map((e) => e.text).join();

                  print("ENTERED OTP $enteredOtp");
                  print("CURRENT OTP $currentOtp");

                  if (enteredOtp.length < 4) {
                    _showSnack("Enter OTP");
                    return;
                  }

                  /// validate frontend
                  if (enteredOtp != currentOtp) {
                    _showSnack("Invalid OTP");
                    return;
                  }

                  /// call same verify api
                  context.read<OtpBloc>().add(
                    VerifyOtpEvent(
                      mobile: widget.mobileNumber,
                      otp: enteredOtp,
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightblue,
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

      /// ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [

                const SizedBox(height: 40),

                Image.asset(
                  "assets/logo.png",
                  height: 130,
                  width: 230,
                ),

                const SizedBox(height: 30),

                /// OTP CONTAINER
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      Text(
                        "Enter OTP sent to ${widget.mobileNumber}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children:
                        List.generate(4, (i) => _otpBox(i)),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "00:${seconds.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          const Text(
                            "Didn't receive the OTP? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          GestureDetector(
                            onTap: seconds == 0
                                ? resendOtp
                                : null,
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: seconds == 0
                                    ? AppColors.lightblue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= OTP BOX =================
  Widget _otpBox(int index) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,

        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),

        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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


  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(message),
      ),
    );
  }
}

