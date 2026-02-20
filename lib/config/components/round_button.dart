import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12), // ripple follows radius
      onTap: onPress,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(12), // ⭐ radius here
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

