import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/routes_name.dart';


class AttachPharmacyPrescriptionScreen extends StatefulWidget {

  final int pharmacyId;
  final String language;
  final String location;

  const AttachPharmacyPrescriptionScreen({
    super.key,
    required this.pharmacyId,
    required this.language,
    required this.location
  });

  @override
  State<AttachPharmacyPrescriptionScreen> createState() =>
      _AttachPharmacyPrescriptionScreenState();
}

class _AttachPharmacyPrescriptionScreenState
    extends State<AttachPharmacyPrescriptionScreen> {

  File? selectedFile;
  String selectedOrderType = "home_delivery";

  final ImagePicker picker = ImagePicker();

  /// CAMERA
  Future<void> pickCamera() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  /// GALLERY
  Future<void> pickGallery() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedFile = File(image.path);
      });
    }
  }

  /// PDF
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  /// BottomSheet
  void showOrderType() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Select Order Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.delivery_dining, color: Colors.green),
                title: const Text("Home Delivery"),
                onTap: () {

                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    RoutesName.confirmPharmacyScreen,
                    arguments: {
                      "file": selectedFile,
                      "pharmacyId": widget.pharmacyId,
                      "orderType": selectedOrderType,
                      "language": widget.language,
                      "location": widget.location,
                    },
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.store, color: Colors.blue),
                title: const Text("Pickup Order"),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.confirmPharmacyScreen,
                    arguments: {
                      "file": selectedFile,
                      "pharmacyId": widget.pharmacyId,
                      "orderType": "pickup_order",
                      "language": widget.language,
                      "location": widget.location,
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
            "Attach Prescription",
            style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor)
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: AppColors.lightblue,
          ),
          onPressed: selectedFile == null ? null : showOrderType,
          child: const Text("Continue",style: TextStyle(color: AppColors.whiteColor,),),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Upload title
            const Text(
              "Upload",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Please upload images of valid prescription from your doctor",
              style: TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 25),

            /// ICON ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                _uploadIcon(
                  icon: Icons.camera_alt,
                  title: "Camera",
                  onTap: pickCamera,
                ),

                _uploadIcon(
                  icon: Icons.photo,
                  title: "Gallery",
                  onTap: pickGallery,
                ),

                _uploadIcon(
                  icon: Icons.picture_as_pdf,
                  title: "PDF",
                  onTap: pickPdf,
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// Preview
            if (selectedFile != null)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedFile!.path.endsWith(".pdf")
                    ? const Center(
                  child: Icon(
                    Icons.picture_as_pdf,
                    size: 60,
                    color: Colors.red,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _uploadIcon({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),

          const SizedBox(height: 6),

          Text(title),
        ],
      ),
    );
  }
}