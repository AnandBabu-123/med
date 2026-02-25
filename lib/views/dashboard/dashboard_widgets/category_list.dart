import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class CategoryItem extends StatelessWidget {
  final String asset;
  final String title;

  const CategoryItem(this.asset, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(child: _icon()),
          ),
          const SizedBox(height: 6),
          Text(title,
              textAlign: TextAlign.center,
              maxLines: 2),
        ],
      ),
    );
  }

  Widget _icon() {
    if (asset.endsWith(".svg")) {
      return SvgPicture.asset(asset, height: 28);
    }
    return Image.asset(asset, height: 28);
  }
}