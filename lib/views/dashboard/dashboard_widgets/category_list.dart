import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class CategoryItem extends StatelessWidget {

  final String image;
  final String title;
  final VoidCallback? onTap;

  const CategoryItem(
      this.image,
      this.title, {
        super.key,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap, // ✅ CLICK EVENT
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(image),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}