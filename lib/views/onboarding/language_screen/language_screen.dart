import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../bloc/language_bloc/language_event.dart';
import '../../../config/colors/app_colors.dart';
import '../../../config/routes/routes_name.dart';
import '../../../network/api_constants.dart';

class LanguageScreen extends StatefulWidget {

  final String from;

  const LanguageScreen({
    super.key,
    required this.from,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _confirmButton(),
      body: SafeArea(
        child: Column(
          children: [

            /// LOGO
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/logo.png",
                height: 120,
                width: 180,
              ),
            ),

            const Divider(thickness: 1),

            const SizedBox(height: 15),

            /// TEXT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "Welcome to Med Rayder App. Choose below language",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Select your language",
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// LANGUAGE OPTIONS
            _languageTile("English", "E"),
            _languageTile("Telugu", "త"),
          ],
        ),
      ),
    );
  }

  /// ================= LANGUAGE TILE =================
  Widget _languageTile(String language, String letter) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() => selectedLanguage = language);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [

            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                letter,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                language,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 26,
              ),
          ],
        ),
      ),
    );
  }

  /// ================= CONFIRM BUTTON =================
  Widget _confirmButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {

            /// UI → API language
            String langCode =
            selectedLanguage == "English" ? "en" : "te";

            /// Save language globally
            context.read<LanguageBloc>().add(
              ChangeLanguage(langCode),
            );

            /// ========= NAVIGATION DECISION =========

            if (widget.from == LanguageSource.dashboard) {

              /// User changed language inside dashboard
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.dashBoardScreens,
                    (route) => false,
              );

            } else {

              /// First time app open
              Navigator.pushReplacementNamed(
                context,
                RoutesName.onBoardingScreen,
                arguments: langCode,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Confirm",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}