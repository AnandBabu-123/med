import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_bloc.dart';
import '../../config/colors/app_colors.dart';
import 'cart_screen.dart';

class PatientDetailsScreen extends StatefulWidget {

  final File? file;
  final int diagnosticId;
  final String language;
  final String location;


  const PatientDetailsScreen({
    super.key,
    this.file,
    required this.diagnosticId,
    required this.language,
    required this.location,

  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState
    extends State<PatientDetailsScreen> {

  int selectedIndex = 0;

  List<String> members = [
    "Shareef",
    "Ahmed",
    "Rahman"
  ];

  List<int> familyIds = [
    558,
    559,
    560
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text("Add Patient Details",style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),),
        backgroundColor: AppColors.lightblue,
        foregroundColor: Colors.white,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:AppColors.lightblue, // button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // radius
            ),
          ),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<DiagnosticPrescriptionBloc>(),
                  child: CartScreen(
                    file: widget.file,
                    name: members[selectedIndex],
                    familyId: familyIds[selectedIndex],
                    diagnosticId: widget.diagnosticId,
                    language: widget.language,
                    location: widget.location,

                  ),
                ),
              ),
            );
          },

          child: const Text("Continue", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),),
        ),
      ),

      body: ListView.builder(

        itemCount: members.length,

        itemBuilder: (context, index) {

          return ListTile(

            title: Text(members[index]),

            leading: Radio(
              value: index,
              groupValue: selectedIndex,

              onChanged: (v) {
                setState(() {
                  selectedIndex = v!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}