import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medryder/network/dio_network/network_info.dart';
import '../../models/family_member_model/total_family_members_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../repository/get_family_members_reposotory/get_family_members_reposotory.dart';
import 'lab_prescription_summary_screen.dart';


class LabPrescriptionFamilyScreen extends StatefulWidget {

  final File file;
  final String fileType;

  const LabPrescriptionFamilyScreen({
    super.key,
    required this.file,
    required this.fileType,
  });

  @override
  State<LabPrescriptionFamilyScreen> createState() =>
      _LabPrescriptionFamilyScreenState();
}

class _LabPrescriptionFamilyScreenState
    extends State<LabPrescriptionFamilyScreen> {

  late Future<List<FamilyMember>> familyFuture;

  FamilyMember? selectedMember;

  @override
  void initState() {
    super.initState();

    final repo = GetFamilyMembersRepository(
      DioClient(dio: Dio(), networkInfo: NetworkInfo()),
    );

    familyFuture = repo.getFamilyMembers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Select Family Member")),

      body: FutureBuilder<List<FamilyMember>>(

        future: familyFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final members = snapshot.data!;

          return Column(
            children: [

              Expanded(
                child: ListView.builder(

                  itemCount: members.length,

                  itemBuilder: (context, index) {

                    final member = members[index];

                    return RadioListTile<FamilyMember>(
                      value: member,
                      groupValue: selectedMember,

                      title: Text(member.name),
                      subtitle: Text(member.type),

                      onChanged: (value) {
                        setState(() {
                          selectedMember = value;
                        });
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: selectedMember == null
                        ? null
                        : () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LabPrescriptionScreen(
                            file: widget.file,
                            fileType: widget.fileType,
                            member: selectedMember!,
                          ),
                        ),
                      );
                    },

                    child: const Text("Continue"),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
