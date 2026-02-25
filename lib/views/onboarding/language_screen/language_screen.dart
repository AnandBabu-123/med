import 'package:flutter/material.dart';
import '../../../config/colors/app_colors.dart';
import '../../../config/routes/routes_name.dart';


class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

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

            /// 🔹 TOP IMAGE
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image.asset(
                "assets/logo.png", // change your image
                height: 120,
                width: 180,
              ),
            ),

            /// 🔹 DIVIDER
            const Divider(thickness: 1),

            const SizedBox(height: 15),

            /// 🔹 TEXTFIELDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "Welcome to Med Rayder App. Choose below language",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue,   // using your color
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',   // your font name
                    ),
                  ),

                  const SizedBox(height: 12),

                 Align(
                 //  alignment: Alignment.topLeft,
                   child: Text("Select your language",
                   textAlign: TextAlign.left,
                   style: TextStyle(
                     color: AppColors.red,
                     fontSize: 24,
                     fontWeight: FontWeight.w700,
                     fontFamily: 'Poppins'
                   ),),
                 )
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🔹 LANGUAGE LIST
            _languageTile("English", "E"),
            _languageTile("Telugu", "త"),
          ],
        ),
      ),
    );
  }

  /// ================= LANGUAGE TILE =================
  Widget _languageTile(String language, String letter) {
    final bool isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8 ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [

            /// 🔹 LANGUAGE ICON LETTER
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                letter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(width: 15),

            /// 🔹 LANGUAGE NAME
            Expanded(
              child: Text(
                language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// 🔹 SELECT ICON
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => OnboardingScreen(
            //       selectedLanguage: selectedLanguage,
            //     ),
            //   ),
            // );

            Navigator.pushNamed(
              context,
              RoutesName.onBoardingScreen,
              arguments: selectedLanguage,
            );
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