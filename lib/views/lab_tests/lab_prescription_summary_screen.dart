import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/family_member_model/total_family_members_model.dart';

class LabPrescriptionScreen extends StatelessWidget {

  final File file;
  final String fileType;
  final FamilyMember member;

  const LabPrescriptionScreen({
    super.key,
    required this.file,
    required this.fileType,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Prescription Details")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Prescription",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            fileType == "image"
                ? Image.file(file, height: 200)
                : Row(
              children: const [
                Icon(Icons.picture_as_pdf,
                    size: 40, color: Colors.red),
                SizedBox(width: 10),
                Text("PDF File")
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Family Member",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Name : ${member.name}"),
            Text("ID : ${member.id}"),
            Text("Relation : ${member.type}"),
          ],
        ),
      ),
    );
  }
}