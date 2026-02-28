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
      onTap: onTap,
      child: SizedBox(
        width: 80, // fixed width for horizontal scroll
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Image Container
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle, // circular shape
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2, // allow wrapping to next line
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}