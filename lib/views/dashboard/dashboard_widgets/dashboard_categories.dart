import 'package:flutter/material.dart';

import '../../../config/routes/routes_name.dart';
import '../dashboard_banner_list/dashboard_banner_list.dart';


class DashboardCategories extends StatelessWidget {
  const DashboardCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // List of categories
    final categories = [
      {"image": "assets/image_three.png", "title": "Ambulance", "route": null},
      {
        "image": "assets/image_one.png",
        "title": "Online Pharmacy",
        "route": RoutesName.pharmacyScreen
      },
      {"image": "assets/image_four.png", "title": "Lab Tests Booking", "route": null},
      {"image": "assets/image_five.png", "title": "Doctor Appointment", "route": null},
      {"image": "assets/image_six.png", "title": "Blood Test", "route": null},
      {"image": "assets/image_seven.png", "title": "More Services", "route": null},
      // Add more items here
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          /// Horizontal Scroll with fixed-height items
          SizedBox(
            height: 130, // fix the total height of each item
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: cat["route"] != null
                        ? () {
                      Navigator.pushNamed(
                        context,
                        cat["route"]!,
                        arguments: "en", // pass language if needed
                      );
                    }
                        : null,
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Circular Image
                          Container(
                            height: 66,
                            width: 66,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              cat["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Fixed height for text so all items align
                          SizedBox(
                            height: 32,
                            child: Text(
                              cat["title"]!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),
          const DashboardBannerList(),
          const SizedBox(height: 30),
          const Text("Dashboard Content"),
          const SizedBox(height: 400),
        ],
      ),
    );
  }
}