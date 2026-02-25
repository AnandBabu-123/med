import 'package:flutter/material.dart';
import '../../../config/colors/app_colors.dart';
import 'location_row.dart';

class DashboardHeader extends StatelessWidget {
  final String? address;
  final ScrollController scrollController;
  final VoidCallback onMenuTap;
  final VoidCallback onLocationTap;

  const DashboardHeader({
    super.key,
    required this.address,
    required this.scrollController,
    required this.onMenuTap,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.lightblue,
        borderRadius:
        BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Column(
        children: [

          /// LOCATION ROW
          LocationRow(
            address: address,
            controller: scrollController,
            onLocationTap: onLocationTap,
          ),

          const SizedBox(height: 15),

          /// MENU + SEARCH
          Row(
            children: [
              GestureDetector(
                onTap: onMenuTap,
                child: _menuIcon(),
              ),
              const SizedBox(width: 12),
              Expanded(child: _searchBar()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuIcon() => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(Icons.menu),
  );

  static Widget _searchBar() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const TextField(
      decoration: InputDecoration(
        hintText: "Search medicines...",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.mic),
      ),
    ),
  );
}