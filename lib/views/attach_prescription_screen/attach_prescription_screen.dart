import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medryder/config/colors/app_colors.dart';
import 'package:medryder/views/attach_prescription_screen/patient_details_screen.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_bloc.dart';

class AttachPrescriptionScreen extends StatefulWidget {

  final int diagnosticId;
  final String language;
  final String location;


  const AttachPrescriptionScreen({
    super.key,
    required this.diagnosticId,
    required this.language,
    required this.location,

  });

  @override
  State<AttachPrescriptionScreen> createState() =>
      _AttachPrescriptionScreenState();
}
class _AttachPrescriptionScreenState
    extends State<AttachPrescriptionScreen> {

  File? selectedFile;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImageCamera() async {

    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  Future<void> pickImageGallery() async {

    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  Future<void> pickPDF() async {

    FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {

      setState(() {
        selectedFile = File(result.files.single.path!);
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text("Attach Prescription",style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),),
        backgroundColor: AppColors.lightblue,
        foregroundColor: Colors.white,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child:
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:AppColors.lightblue, // button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // radius
            ),
          ),
          onPressed: selectedFile == null
              ? null
              : () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<DiagnosticPrescriptionBloc>(),
                  child: PatientDetailsScreen(
                    file: selectedFile,
                    diagnosticId: widget.diagnosticId,
                    language: widget.language,
                    location: widget.location,
                  ),
                ),
              ),
            );
          },

          child: const Text("Continue", style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),),
        ),
      ),

      body:
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Text(
              "Please upload images of valid prescription from your doctor",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                /// CAMERA
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: pickImageCamera,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("Camera"),
                  ],
                ),

                /// GALLERY
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: pickImageGallery,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("Gallery"),
                  ],
                ),

                /// PDF
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        onPressed: pickPDF,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("PDF"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            if (selectedFile != null)
              SizedBox(
                height: 150,
                child: selectedFile!.path.endsWith(".pdf")
                    ? const Icon(Icons.picture_as_pdf, size: 120)
                    : Image.file(selectedFile!),
              ),
          ],
        ),
      )
    );
  }
}