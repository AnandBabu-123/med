import 'package:flutter/material.dart';

import '../../../config/routes/routes_name.dart';
import '../dashboard_banner_list/dashboard_banner_list.dart';


class DashboardCategories extends StatelessWidget {
  final String? lat;
  final String? lon;
  final String language;
  final VoidCallback onLocationRequired;

  const DashboardCategories({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
    required this.onLocationRequired,
  });

  @override
  Widget build(BuildContext context) {

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
      {
        "image": "assets/image_seven.png",
        "title": "More Services",
        "route": RoutesName.diagnosticScreen
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [

          /// CATEGORY LIST
          SizedBox(
            height: 130,
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

                      /// ✅ ASK LOCATION ONLY WHEN REQUIRED
                      if (lat == null || lon == null) {
                        onLocationRequired();
                        return;
                      }

                      Navigator.pushNamed(
                        context,
                        cat["route"]!,
                        arguments: {
                          "lat": lat,
                          "lon": lon,
                          "language": language,
                        },
                      );
                    }
                        : null,

                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            height: 66,
                            width: 66,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(cat["image"]!),
                          ),

                          const SizedBox(height: 6),

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