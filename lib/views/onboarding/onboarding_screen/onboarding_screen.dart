import 'package:flutter/material.dart';
import '../../../config/colors/app_colors.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/language/app_strings.dart';
import '../signup_screen/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String selectedLanguage;

  const OnboardingScreen({
    super.key,
    required this.selectedLanguage,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  /// 🔹 PAGE CONTROLLER
  final PageController _pageController = PageController();

  int _currentPage = 0;
  Timer? _timer;

  /// 🔹 IMAGES LIST
  final List<String> images = [
    "assets/img.png",
    "assets/img_1.png",
    "assets/img_2.png",
    "assets/img_3.png",
    "assets/img_4.png",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  /// ✅ AUTO SLIDE
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _currentPage++;

      if (_currentPage >= images.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final getStarted =
    AppStrings.get(widget.selectedLanguage, "getStarted");

    final enterMobile =
    AppStrings.get(widget.selectedLanguage, "enterMobile");

    final hintMobile =
    AppStrings.get(widget.selectedLanguage, "hintMobile");

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 LOGO
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 120,
                  width: 180,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔥 AUTO SLIDER
              Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _card(images[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 DOT INDICATOR
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: images.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔹 LETS GET STARTED
              Text(
                getStarted,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 ENTER MOBILE
              Text(
                enterMobile,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 MOBILE INPUT
              TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignupScreen(
                        selectedLanguage: widget.selectedLanguage,
                      ),
                    ),
                  );
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: hintMobile,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 CARD UI
  Widget _card(String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
