import 'package:flutter/material.dart';

import '../../config/routes/app_url.dart';

class LabSummaryScreen extends StatelessWidget {

  final int labTestId;
  final int testId;
  final int slotId;
  final String date;
  final int fee;

  final List<int> selectedMembers;
  final int patientCount;
  final int price;
  final String image;

  const LabSummaryScreen({
    super.key,
    required this.labTestId,
    required this.testId,
    required this.slotId,
    required this.date,
    required this.fee,
    required this.selectedMembers,
    required this.patientCount,
    required this.price,
    required this.image
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Lab Test Summary"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TEST DETAILS
            _sectionTitle("Test Details"),
            _testDetailsCard(),

            const SizedBox(height: 20),

            /// DATE & SLOT
            _sectionTitle("Appointment Details"),
            _dateSlotCard(),

            const SizedBox(height: 20),

            /// FAMILY MEMBERS
            _sectionTitle("Patients"),
            _familyCard(),

            const SizedBox(height: 20),

            /// PRICE SUMMARY
            _sectionTitle("Price Summary"),
            _priceCard(),

            const SizedBox(height: 30),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  print("Booking Confirmed");

                },
                child: const Text("Confirm Booking"),
              ),
            )

          ],
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// TEST DETAILS CARD
  Widget _testDetailsCard() {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          children: [

            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (image.isEmpty || image == "null")
                  ? Image.asset(
                "assets/logo.png",
                width: 70,
                height: 100,
                fit: BoxFit.cover,
              )
                  : Image.network(
                "${AppUrl.imageBaseUrl}/${image}",
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/logo.png",
                    width: 70,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Complete Blood Test",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Lab Test",
                    style: TextStyle(color: Colors.grey),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  /// DATE SLOT CARD
  Widget _dateSlotCard() {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text("Date"),
                Text(date),

              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text("Slot ID"),
                Text("$slotId"),

              ],
            ),

          ],
        ),
      ),
    );
  }

  /// FAMILY MEMBERS CARD
  Widget _familyCard() {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Patients Count: $patientCount"),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: selectedMembers.map((id) {

                return Chip(
                  label: Text("Member ID: $id"),
                );

              }).toList(),
            ),

          ],
        ),
      ),
    );
  }

  /// PRICE CARD
  Widget _priceCard() {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              "Total Amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "₹$price",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}