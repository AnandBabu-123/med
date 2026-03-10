import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_bloc.dart';
import '../../config/colors/app_colors.dart';
import '../../models/family_member_model/total_family_members_model.dart';
import 'cart_screen.dart';
import '../../bloc/get_family_members_bloc/get_family_members_bloc.dart';
import '../../bloc/get_family_members_bloc/get_family_members_state.dart';


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

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {

  List<int> selectedIds = [];
  List<String> selectedNames = [];
  List<int> selectedMobiles = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      /// APPBAR
      appBar: AppBar(
        title: const Text(
          "Add Patient Details",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.lightblue,
      ),

      /// CONTINUE BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          onPressed: () {

            if (selectedIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a patient")),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<DiagnosticPrescriptionBloc>(),
                  child: CartScreen(
                    file: widget.file,
                    name: selectedNames.join(", "),
                    familyIds: selectedIds,
                    diagnosticId: widget.diagnosticId,
                    language: widget.language,
                    location: widget.location,
                    mobile: selectedMobiles.first.toString(),
                  ),
                ),
              ),
            );
          },

          child: const Text(
            "Continue",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),

      /// BODY
      body: BlocBuilder<GetFamilyMembersBloc, GetFamilyMembersState>(

        builder: (context, state) {

          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text(state.error));
          }

          if (state.members.isEmpty) {
            return const Center(child: Text("No family members found"));
          }

          return ListView.builder(

            itemCount: state.members.length,

            itemBuilder: (context, index) {

              final FamilyMember member = state.members[index];

              final selected = selectedIds.contains(member.id);

              return CheckboxListTile(

                title: Text(member.name),

                value: selected,

                onChanged: (value) {

                  setState(() {

                    if (value == true) {

                      selectedIds.add(member.id);
                      selectedNames.add(member.name);
                      selectedMobiles.add(member.mobile);

                    } else {

                      selectedIds.remove(member.id);
                      selectedNames.remove(member.name);
                      selectedMobiles.remove(member.mobile);
                    }

                  });

                },
              );
            },
          );
        },
      ),
    );
  }
}