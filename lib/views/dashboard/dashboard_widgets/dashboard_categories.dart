import 'package:flutter/material.dart';

import '../../../config/routes/routes_name.dart';
import '../dashboard_banner_list/dashboard_banner_list.dart';
import 'category_list.dart';

class DashboardCategories extends StatelessWidget {
  const DashboardCategories({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          /// CATEGORY LIST
          SizedBox(
            height: 115,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [

                const CategoryItem(
                  "assets/image_three.png",
                  "Ambulance",
                ),

                /// ✅ CLICK NAVIGATION
                CategoryItem(
                  "assets/image_one.png",
                  "Online Pharmacy",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.pharmacyScreen,
                      arguments: "en", // pass language
                    );
                  },
                ),

                const CategoryItem(
                  "assets/image_four.png",
                  "Lab Tests Booking",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const DashboardBannerList(),

          const SizedBox(height: 30),
          const Text("Dashboard Content"),
          const SizedBox(height: 400),
        ],
      ),
    );
  }
}