import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'lab_prescription_family_screen.dart';

class AttachPrescriptionScreen extends StatefulWidget {
  const AttachPrescriptionScreen({super.key});

  @override
  State<AttachPrescriptionScreen> createState() =>
      _AttachPrescriptionScreenState();
}

class _AttachPrescriptionScreenState extends State<AttachPrescriptionScreen> {

  File? selectedFile;
  String? fileType;

  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        selectedFile = File(picked.path);
        fileType = "image";
      });
    }
  }

  Future pickPdf() async {

    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileType = "pdf";
      });
    }
  }

  Widget previewFile() {

    if (selectedFile == null) return const SizedBox();

    if (fileType == "image") {
      return Image.file(selectedFile!, height: 200);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
          SizedBox(width: 10),
          Text("PDF Selected")
        ],
      ),
    );
  }

  Widget optionItem(IconData icon, String title, VoidCallback onTap) {

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 6),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Attach Prescription")),

      body: Column(
        children: [

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              optionItem(
                Icons.camera_alt,
                "Camera",
                    () => pickImage(ImageSource.camera),
              ),

              optionItem(
                Icons.photo,
                "Gallery",
                    () => pickImage(ImageSource.gallery),
              ),

              optionItem(
                Icons.picture_as_pdf,
                "PDF",
                pickPdf,
              ),
            ],
          ),

          const SizedBox(height: 20),

          previewFile(),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(

                onPressed: selectedFile == null
                    ? null
                    : () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LabPrescriptionFamilyScreen(
                        file: selectedFile!,
                        fileType: fileType!,
                      ),
                    ),
                  );
                },

                child: const Text("Continue"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
