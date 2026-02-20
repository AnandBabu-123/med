import 'package:flutter/material.dart';

import 'dart:async';
import '../../../config/colors/app_colors.dart';
import '../../../config/language/app_strings.dart';
import '../../dashboard_screen/dashboard_screen.dart';


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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final enterOtp =
    AppStrings.get(widget.selectedLanguage, "enterOtp");

    final didntReceive =
    AppStrings.get(widget.selectedLanguage, "didntReceive");

    final resend =
    AppStrings.get(widget.selectedLanguage, "resend");

    final continueText =
    AppStrings.get(widget.selectedLanguage, "continue");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        // backgroundColor: Colors.white,
      ),

      /// ✅ Bottom Button
      bottomNavigationBar: _continueButton(continueText),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// IMAGE
              Image.asset(
                "assets/logo.png",
                height: 150,
              ),

              const SizedBox(height: 25),

              /// OTP CONTAINER
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  children: [

                    Text(
                      "$enterOtp ${widget.mobileNumber}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// OTP BOXES
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                            (index) => _otpBox(index),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// RESEND + TIMER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(didntReceive),

                  GestureDetector(
                    onTap: seconds == 0 ? startTimer : null,
                    child: Text(
                      " $resend",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text("00:${seconds.toString().padLeft(2, '0')}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// OTP BOX
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
            borderRadius: BorderRadius.circular(10),
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

  /// CONTINUE BUTTON
  Widget _continueButton(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {

            /// 🔹 GET OTP VALUE
            String otp =
            controllers.map((e) => e.text).join();

            /// ✅ EMPTY VALIDATION
            if (otp.isEmpty || otp.length < 4) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Please enter OTP"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
                ),
              );
              return;
            }

            /// ✅ DEMO OTP CHECK
            if (otp == "1234") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Invalid OTP"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
