import 'package:flutter/material.dart';
import 'package:medryder/config/colors/app_colors.dart';

class HospitalDiagnosticBookings extends StatelessWidget {
  const HospitalDiagnosticBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,

        /// ---------- APP BAR ----------
        appBar: AppBar(
          backgroundColor:AppColors.lightblue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Hospital Diagnostic Bookings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        /// ---------- BODY ----------
        body: Column(
          children: [

            /// ✅ WHITE GAP BETWEEN APPBAR & TABS
            const SizedBox(height: 16),

            /// ---------- TAB SECTION ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),

                ),

                child: TabBar(
                  indicator: BoxDecoration(

                    color: AppColors.lightblue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: AppColors.whiteColor,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "BOOKINGS"),
                    Tab(text: "COMPLETED"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ---------- TAB VIEW ----------
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text("No Bookings")),
                  Center(child: Text("No Bookings ")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
