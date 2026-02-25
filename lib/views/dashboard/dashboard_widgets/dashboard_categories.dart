import 'package:flutter/material.dart';

import 'category_list.dart';

class DashboardCategories extends StatelessWidget {
  const DashboardCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(
            height: 115,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryItem("assets/image_three.png","Ambulance"),
                CategoryItem("assets/image_one.png","Online Pharmacy"),
                CategoryItem("assets/image_four.png","Lab Tests Booking"),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Text("Dashboard Content"),
          const SizedBox(height: 400),
        ],
      ),
    );
  }
}