import 'package:flutter/material.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../../bloc/signup_bloc/signup_bloc.dart';
import '../../../bloc/signup_bloc/signup_event.dart';
import '../../../bloc/signup_bloc/signup_state.dart';
import '../../../config/language/app_strings.dart';
import '../../../config/routes/routes_name.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return BlocListener<SignupBloc, SignupState>(

      /// ✅ VERY IMPORTANT (prevents multiple calls)
      listenWhen: (previous, current) =>
      previous.runtimeType != current.runtimeType,

      listener: (context, state) {

        /// ✅ OTP SUCCESS → NAVIGATE
        if (state is SignupOtpSent) {

          Navigator.pushReplacementNamed(
            context,
            RoutesName.otpScreen,
            arguments: {
              "mobile": mobileController.text.trim(),
              "language": widget.selectedLanguage,
              "otp": state.otp,
            },
          );
        }

        /// ❌ ERROR STATE
        if (state is SignupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar:
        _continueButton(context, continueText),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---------- LOGO ----------
                Center(
                  child: Image.asset(
                    "assets/logo.png",
                    height: 170,
                    width: 180,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  enterMobile,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(phone),

                const SizedBox(height: 8),

                /// ---------- MOBILE ----------
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: hintMobile,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(referral),

                const SizedBox(height: 8),

                /// ---------- REFERRAL ----------
                TextField(
                  controller: referralController,
                  decoration: InputDecoration(
                    hintText: hintReferral,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= CONTINUE BUTTON =================
  Widget _continueButton(
      BuildContext context, String continueText) {

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {

            final bool isLoading = state is SignupLoading;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {

                final mobile =
                mobileController.text.trim();

                /// ✅ SAME VALIDATION AS ANDROID
                if (!RegExp(r'^[6-9]\d{9}$')
                    .hasMatch(mobile)) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Enter valid mobile number"),
                    ),
                  );
                  return;
                }

                /// ✅ CALL BLOC EVENT
                context.read<SignupBloc>().add(
                  SendOtpEvent(
                    mobile: mobile,
                    referral:
                    referralController.text
                        .trim(),
                    playerId: "ONESIGNAL_ID",
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightblue,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),

              child: isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                continueText,
                style: const TextStyle(
                    color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
