import 'package:flutter/material.dart';

import '../../config/colors/app_colors.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../models/online_doctors_model/online_doctor_speciality_model.dart';
import 'doctor_summary_screen.dart';

class PatientDetailsScreen extends StatefulWidget {

  final Doctor doctor;
  final Slots slot;
  final List<FamilyMember> familyMembers;

  const PatientDetailsScreen({
    super.key,
    required this.doctor,
    required this.slot,
    required this.familyMembers,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {

  FamilyMember? selectedMember;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar:  AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
            "Patient Details",
            style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 20)
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),

          onPressed: selectedMember == null
              ? null
              : () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorSummaryScreen(
                  doctor: widget.doctor,
                  slot: widget.slot,
                  patient: selectedMember!,
                ),
              ),
            );
          },

          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.familyMembers.length,

        itemBuilder: (context, index) {

          final member = widget.familyMembers[index];

          final isSelected =
              selectedMember?.id == member.id;

          return GestureDetector(

            onTap: () {
              setState(() {
                selectedMember = member;
              });
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 10),

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                border: Border.all(
                  color: isSelected
                      ? Colors.blue
                      : Colors.grey.shade300,
                ),
              ),

              child: Row(
                children: [

                  Icon(
                    Icons.person,
                    color: isSelected
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        member.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(member.type),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
