import 'package:flutter/material.dart';
import 'location_bottomsheet.dart';

class LocationRow extends StatelessWidget {
  final String? address;
  final ScrollController controller;
  final VoidCallback onLocationTap;

  const LocationRow({
    super.key,
    required this.address,
    required this.controller,
    required this.onLocationTap,
  });

  /// reusable circle icon
  Widget _circleIcon(IconData icon) {
    return Container(
      height: 36,
      width: 36,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// LOCATION ICON
        GestureDetector(
          onTap: onLocationTap,
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 6),

        /// AUTO SCROLL ADDRESS TEXT
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Text(
              address ?? "Select Location",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        /// ✅ CREDIT CARD ICON
        _circleIcon(Icons.credit_card),

        const SizedBox(width: 10),

        /// ✅ NOTIFICATION ICON
        _circleIcon(Icons.notifications),
      ],
    );
  }
}