import 'package:flutter/material.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../../config/language/app_strings.dart';
import '../../../config/routes/routes_name.dart';


import 'package:flutter/material.dart';


class SignupScreen extends StatefulWidget {
  final String selectedLanguage;

  const SignupScreen({
    super.key,
    required this.selectedLanguage,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  /// ✅ Controller must be here (NOT inside build)
  final TextEditingController mobileController =
  TextEditingController();

  final TextEditingController referralController =
  TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 🔹 LANGUAGE STRINGS
    final termsPrefix =
    AppStrings.get(widget.selectedLanguage, "termsPrefix");

    final termsLink =
    AppStrings.get(widget.selectedLanguage, "termsLink");

    final enterMobile =
    AppStrings.get(widget.selectedLanguage, "enterMobile");

    final phone =
    AppStrings.get(widget.selectedLanguage, "phone");

    final hintMobile =
    AppStrings.get(widget.selectedLanguage, "hintMobile");

    final referral =
    AppStrings.get(widget.selectedLanguage, "referralOptional");

    final hintReferral =
    AppStrings.get(widget.selectedLanguage, "hintReferral");

    final continueText =
    AppStrings.get(widget.selectedLanguage, "continue");

    return Scaffold(
      resizeToAvoidBottomInset: true,

      /// ✅ FIXED BOTTOM BUTTON
      bottomNavigationBar: _continueButton(context, continueText),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ---------- TOP IMAGE ----------
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 170,
                  width: 180,
                ),
              ),

              const SizedBox(height: 20),

              /// ---------- TITLE ----------
              Text(
                enterMobile,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// ---------- PHONE LABEL ----------
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              /// ---------- MOBILE FIELD ----------
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: hintMobile,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------- REFERRAL TEXT ----------
              Text(
                referral,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 8),

              /// ---------- REFERRAL FIELD ----------
              TextField(
                controller: referralController,
                decoration: InputDecoration(
                  hintText: hintReferral,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------- TERMS ----------
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(text: termsPrefix),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: termsLink,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ CONTINUE BUTTON (BOTTOM FIXED)
  Widget _continueButton(BuildContext context, String continueText) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final mobile = mobileController.text.trim();

            /// ✅ MOBILE VALIDATION
            if (mobile.isEmpty || mobile.length != 10) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Please enter 10 digit mobile number",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// ✅ floating from bottom
                  behavior: SnackBarBehavior.floating,

                  /// ✅ rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),

                  /// ✅ space from screen edges
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                  /// optional styling
                  backgroundColor: Colors.black87,
                  duration: const Duration(seconds: 2),
                  elevation: 6,
                ),
              );
              return;
            }

            /// ✅ NAVIGATE TO OTP SCREEN
            Navigator.pushNamed(
              context,
              RoutesName.otpScreen,
              arguments: {
                "mobile": mobile,
                "language": widget.selectedLanguage,
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            continueText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
