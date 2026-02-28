import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medryder/config/colors/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/profile_bloc/profile_state.dart';
import '../../models/profile_request_model.dart';




class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  /// CONTROLLERS
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  /// DROPDOWNS VALUES
  String? gender;
  String? bloodGroup;
  String? coverage;
  String? relationship;

  /// DROPDOWN LISTS
  final Map<String, String> genderList = {
    "1": "Male",
    "2": "Female",
  };

  final Map<String,String> bloodGroupList = {
    "1":"A+",
    "2":"A-",
    "3":"B+",
    "4":"B-",
    "5":"O+",
    "6":"O-",
    "7":"AB+",
    "8":"AB-",
  };

  final Map<String,String> coverageList = {
    "1":"Health Insurance",
    "2":"ESIC/EHS/CGHS",
    "3":"Aarogya Sree",
    "4":"Cash",
    "5":"Other",
  };
  final relationshipList = [
    "Father",
    "Mother",
    "Son",
    "Daughter"
  ];

  /// IMAGE
  File? profileImage;
  final picker = ImagePicker();

  // ================= DATE PICKER =================
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
      setState(() {});
    }
  }

  // ================= IMAGE PICK =================
  void showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Camera"),
          onTap: () {
            Navigator.pop(context);
            pickImage(ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo),
          title: const Text("Gallery"),
          onTap: () {
            Navigator.pop(context);
            pickImage(ImageSource.gallery);
          },
        ),
      ]),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() => profileImage = File(image.path));
    }
  }



  Future<String> convertImageToBase64(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> submitProfile() async {

    if (!_formKey.currentState!.validate()) return;

    if (gender == null ||
        bloodGroup == null ||
        coverage == null ||
        relationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all dropdown values")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt("user_id") ?? 0;

    /// ✅ Convert image
    String base64Image = "";

    if (profileImage != null) {
      base64Image = await convertImageToBase64(profileImage!);
    }

    final request = ProfileRequestModel(
      image: base64Image,
      gender: int.parse(gender!),
      coverageCategory: int.parse(coverage!),
      userId: userId,
      dob: dobController.text,
      name: nameController.text.trim(),
      mobile: int.parse(phoneController.text.trim()),
      bloodGroup: int.parse(bloodGroup!),
      email: emailController.text.trim(),
    );

    debugPrint("===== FINAL BODY =====");
    debugPrint(request.toJson().toString());

    context.read<ProfileBloc>().add(
      SubmitProfileEvent(
        request: request,
        image: profileImage,
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {

        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        }

        if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.lightblue,
            title: const Text("Profile",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
          ),

          body: Stack(
            children: [

              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      /// IMAGE
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage!)
                                : const AssetImage("assets/man_icon.png")
                            as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: showImagePickerOption,
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      buildTextField("Name", nameController),
                      buildTextField("Phone", phoneController,
                          keyboardType: TextInputType.phone),
                      buildTextField("Email", emailController,
                          keyboardType: TextInputType.emailAddress),

                      buildDateField(),

                      buildDropdown(
                        label: "Gender",
                        value: gender,
                        items: genderList,
                        onChanged: (val) => setState(() => gender = val),
                      ),

                      buildDropdown(
                        label: "Blood Group",
                        value: bloodGroup,
                        items: bloodGroupList,
                        onChanged: (val) => setState(() => bloodGroup = val),
                      ),

                      buildDropdown(
                        label: "Coverage",
                        value: coverage,
                        items: coverageList,
                        onChanged: (val) => setState(() => coverage = val),
                      ),

                      buildDropdownRelationShip(
                        label: "Relationship",
                        value: relationship,
                        items: relationshipList,
                        onChanged: (val) => setState(() => relationship = val),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.status ==
                              ProfileStatus.loading
                              ? null
                              : submitProfile,
                          child: const Text("Update"),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              if (state.status == ProfileStatus.loading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                      child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  // ================= TEXTFIELD =================
  Widget buildTextField(String label,
      TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (v) =>
        v == null || v.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ================= DATE FIELD =================
  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: dobController,
        readOnly: true,
        onTap: pickDate,
        validator: (v) =>
        v == null || v.isEmpty ? "Select DOB" : null,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ================= DROPDOWN =================
  Widget buildDropdownRelationShip({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Select $label" : null,
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required Map<String, String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        /// ✅ KEY = API VALUE
        /// ✅ VALUE = DISPLAY TEXT
        items: items.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,        // API ID
            child: Text(entry.value), // UI Text
          );
        }).toList(),

        onChanged: onChanged,
        validator: (v) => v == null ? "Select $label" : null,
      ),
    );
  }
}