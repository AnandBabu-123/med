import 'package:flutter/material.dart';
import '../../config/routes/routes_name.dart';
import 'dart:async';
import '../../utils/session_manager.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // === Animation setup (Zoom in + Fade) ===
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // === Navigate after delay + check token + userId ===
    Timer(const Duration(seconds: 2), () async {
      final userId = await SessionManager.getUserId();
      final token = await SessionManager.getToken();

      if (userId != null && token != null && token.isNotEmpty) {
        // ✅ User is logged in → go Dashboard
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutesName.dashBoardScreens);
      } else {
        // ❌ Not logged in → go Language Screen
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutesName.languageScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            "assets/app_logo.png", // your splash png
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
