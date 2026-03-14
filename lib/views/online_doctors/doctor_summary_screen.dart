import 'package:flutter/material.dart';

import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../models/online_doctors_model/online_doctor_speciality_model.dart';


class DoctorSummaryScreen extends StatelessWidget {

  final Doctor doctor;
  final Slots slot;
  final FamilyMember patient;

  const DoctorSummaryScreen({
    super.key,
    required this.doctor,
    required this.slot,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
            "Booking Summary",
            style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 20)
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [

            Text(
              "₹${doctor.fee}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),

              onPressed: () {

                /// CALL BOOK API
              },

              child: const Text(
                "Pay",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// Doctor Card

            Row(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),

                  child: Image.network(
                    "${AppUrl.imageBaseUrl}/${doctor.image}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    Text(doctor.specialization),

                    Text("${doctor.exp} years exp"),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            /// Slot Info

            const Text(
              "Appointment Time",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text("${slot.date}  •  ${slot.time}"),

            const SizedBox(height: 20),

            /// Patient

            const Text(
              "Patient",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(patient.name),

            const SizedBox(height: 20),

            /// Coupon

            const TextField(
              decoration: InputDecoration(
                hintText: "Enter Coupon Code",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Contact

            const TextField(
              decoration: InputDecoration(
                hintText: "Contact Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Consultation Fee",
                  style: TextStyle(fontSize: 16),
                ),

                Text(
                  "₹${doctor.fee}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}