import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_bloc.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_event.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_state.dart';
import 'dart:convert';
class CartScreen extends StatefulWidget {

  final File? file;
  final String name;
  final List<int> familyIds;
  final int diagnosticId;
  final String language;
  final String location;
  final String mobile;
  const CartScreen({
    super.key,
    this.file,
    required this.name,
    required this.familyIds,
    required this.diagnosticId,
    required this.language,
    required this.location,
    required this.mobile,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Future<String> convertToBase64(File file) async {
    List<int> bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.lightblue,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: BlocConsumer<DiagnosticPrescriptionBloc,
            DiagnosticPrescriptionState>(

          listener: (context, state) {

            if (state.success) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (!state.success && state.message.isNotEmpty) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },

          builder: (context, state) {

            return ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: state.loading
                  ? null
                  : () async {

                if (widget.file == null) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please upload prescription"),
                    ),
                  );

                  return;
                }

                String base64Image =
                await convertToBase64(widget.file!);

                context.read<DiagnosticPrescriptionBloc>().add(

                  UploadPrescriptionEvent(
                    diagnosticId: widget.diagnosticId,
                    base64Image: base64Image,
                    name: widget.name,
                    mobile: widget.mobile, // ✅ FIXED
                    familyMemberId: widget.familyIds,
                    language: widget.language,
                  ),
                );
              },

              child: state.loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Prescription Order",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.light_green,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Row(
                children: [

                  const Icon(Icons.location_on,color: Colors.green),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(widget.location),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (widget.file != null)
              Container(
                height: 140,
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: widget.file!.path.endsWith(".pdf")

                    ? const Icon(Icons.picture_as_pdf,size: 70,color: Colors.red)

                    : Image.file(widget.file!,fit: BoxFit.contain),
              ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Row(
                children: [

                  const Icon(Icons.person,color: Colors.blue),

                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Patient Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      Text(widget.name),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}