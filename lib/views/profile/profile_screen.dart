import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medryder/config/colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  /// ---------- FORM KEY ----------
  final _formKey = GlobalKey<FormState>();

  /// ---------- CONTROLLERS ----------
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  /// ---------- DROPDOWN VALUES ----------
  String? gender;
  String? bloodGroup;
  String? coverage;
  String? relationship;

  /// ---------- IMAGE ----------
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  /// ---------- LISTS ----------
  final genderList = ["Male", "Female",];
  final bloodGroupList = ["A+","A-","B+","B-","O+","O-","AB+","AB-"];
  final coverageList = ["Health Insurance", "ESIC/EHS/CGHS","Aarogya Sree","Cash","Other","Aarogya Sree and Health Insurance"];
  final relationshipList = ["Father","Mother","Son","Daughter"];

  /// ---------- DATE PICKER ----------
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text =
      "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  /// ---------- IMAGE OPTIONS ----------
  void showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () async {
                Navigator.pop(context);
                await pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () async {
                Navigator.pop(context);
                await pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image =
    await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  /// ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        leading: const BackButton(color: Colors.white),
        title:
        const Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// -------- STEPPER ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Row(
                    children: [
                      Container(
                        width: 30,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lightblue,
                        ),
                        child: Text("${index + 1}",
                            style: const TextStyle(
                                color: Colors.white)),
                      ),
                      if (index != 4)
                        Container(width: 40, height: 2, color: AppColors.lightblue),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 25),

              /// -------- PROFILE IMAGE ----------
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : const AssetImage("assets/profile.png")
                    as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: showImagePickerOption,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// -------- FORM FIELDS ----------
              buildTextField("Name", nameController),
              buildTextField("Phone Number", phoneController,
                  keyboardType: TextInputType.phone),
              buildTextField("Email ID", emailController,
                  keyboardType: TextInputType.emailAddress),

              buildDropdown("Gender", gender, genderList,
                      (v) => setState(() => gender = v)),

              buildDateField(),

              buildDropdown("Blood Group", bloodGroup,
                  bloodGroupList,
                      (v) => setState(() => bloodGroup = v)),

              /// OPTIONAL
              buildDropdown("Coverage Category", coverage,
                  coverageList,
                      (v) => setState(() => coverage = v),
                  required: false),

              buildDropdown("Relationship", relationship,
                  relationshipList,
                      (v) => setState(() => relationship = v)),

              const SizedBox(height: 30),

              /// -------- UPDATE BUTTON ----------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile Updated"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- LABEL ----------
  Widget buildLabel(String title, {bool required = true}) {
    return RichText(
      text: TextSpan(
        text: title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600),
        children: required
            ? const [
          TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red))
        ]
            : [],
      ),
    );
  }

  /// ---------- TEXTFIELD ----------
  Widget buildTextField(
      String title,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14), // reduced spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(title),
          const SizedBox(height: 6),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: (v) =>
            v == null || v.isEmpty ? "$title is required" : null,
            style: const TextStyle(fontSize: 14), // smaller text
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- DATE ----------
  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel("Date of Birth"),
          const SizedBox(height: 6),

          TextFormField(
            controller: dobController,
            readOnly: true,
            onTap: pickDate,
            validator: (v) =>
            v == null || v.isEmpty ? "Date of Birth required" : null,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true, //  reduce height
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              suffixIcon: const Icon(
                Icons.calendar_month,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- DROPDOWN ----------
  Widget buildDropdown(
      String title,
      String? value,
      List<String> items,
      Function(String?) onChanged, {
        bool required = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(title, required: required),
          const SizedBox(height: 6),

          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.black,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            validator: (v) =>
            required && v == null ? "Select $title" : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            hint: Text(
              "Select $title",
              style: const TextStyle(color: Colors.black54),
            ),

            ///  dropdown items text color fix
            items: items.map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}