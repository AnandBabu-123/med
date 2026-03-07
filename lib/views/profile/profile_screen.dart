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
import '../../config/routes/routes_name.dart';
import '../../models/profile_request_model/profile_request_model.dart';

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

  /// DROPDOWN VALUES
  String? gender;
  String? bloodGroup;
  String? coverage;
  String? relationship;

  /// DROPDOWN DATA
  Map<String,String> genderList = {};
  Map<String,String> bloodGroupList = {};
  Map<String,String> coverageList = {};

  final relationshipList = [
    "Father",
    "Mother",
    "Son",
    "Daughter"
  ];

  /// IMAGE
  File? profileImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    /// LOAD DROPDOWNS
    context.read<ProfileBloc>().add(
      LoadProfileDropdowns(language: "en"),
    );
  }

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
      "${picked.year}-${picked.month}-${picked.day}";
      setState(() {});
    }
  }

  // ================= IMAGE PICK =================

  void showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [

          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: (){
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),

          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: (){
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),

        ],
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70, // compress image like native
      maxHeight: 512,
      maxWidth: 512,
    );

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  // ================= IMAGE BASE64 =================

  Future<String> convertImageToBase64(File image) async {

    List<int> imageBytes = await image.readAsBytes();

    String base64Image = base64Encode(imageBytes);

    print("BASE64 LENGTH : ${base64Image.length}");

    return base64Image;
  }

  // ================= SUBMIT PROFILE =================

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
    final String token = prefs.getString("auth_token") ?? "";

    /// IMAGE BASE64
    String base64Image = "";

    if (profileImage != null) {
      base64Image = await convertImageToBase64(profileImage!);
      print("IMAGE BASE64 GENERATED");
    } else {
      print("NO IMAGE SELECTED");
    }

    final request = ProfileRequestModel(
      userId: userId,
      authToken: token,
      name: nameController.text.trim(),
      mobile: phoneController.text.trim(),
      email: emailController.text.trim(),
      dob: dobController.text,

      gender: gender!,
      bloodGroup: bloodGroup!,
      coverageCategory: coverage!,
      relationship: relationship!,

      image: base64Image,
    );


    /// PRINT BODY
    print("========= PROFILE REQUEST BODY =========");
    print(request.toJson());

    context.read<ProfileBloc>().add(
      SubmitProfileEvent(
        request: request,
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {

        /// DROPDOWN DATA
        if(state.status == ProfileStatus.dropdownLoaded){

          genderList = state.genderList;
          bloodGroupList = state.bloodGroupList;
          coverageList = state.coverageList;

        }

        if(state.status == ProfileStatus.success){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.dashBoardScreens,
                (route) => false,
          );
        }

        if(state.status == ProfileStatus.failure){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

      },
      builder: (context, state) {

        return Scaffold(

          appBar: AppBar(
            backgroundColor: AppColors.lightblue,
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )

                        ],
                      ),

                      const SizedBox(height: 25),

                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Name",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildTextField("", nameController),
                      SizedBox(height: 10,),

                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Phone",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildTextField(
                        "",
                        phoneController,
                        keyboardType: TextInputType.phone,
                      ),

                SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Email",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildTextField(
                        "",
                        emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Date of Birth",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildDateField(),

                      SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Gender",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildDropdown(
                        label: "",
                        value: gender,
                        items: genderList,
                        onChanged: (val){
                          setState(() {
                            gender = val;
                          });
                        },
                      ),

                      SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Blood Group",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildDropdown(
                        label: "",
                        value: bloodGroup,
                        items: bloodGroupList,
                        onChanged: (val){
                          setState(() {
                            bloodGroup = val;
                          });
                        },
                      ),

                      SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Coverage",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),

                            ],
                          )),
                      SizedBox(height: 0,),
                      buildDropdown(
                        label: "",
                        value: coverage,
                        items: coverageList,
                        onChanged: (val){
                          setState(() {
                            coverage = val;
                          });
                        },
                      ),

                      SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text("Relationship",style: TextStyle(fontSize: 14,color: AppColors.black,fontWeight: FontWeight.w500),),
                              SizedBox(width: 2,),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          )),
                      SizedBox(height: 0,),
                      buildDropdownRelationShip(
                        label: "",
                        value: relationship,
                        items: relationshipList,
                        onChanged: (val){
                          setState(() {
                            relationship = val;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.lightblue, // button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // radius
                            ),
                          ),
                          onPressed: state.status == ProfileStatus.loading
                              ? null
                              : submitProfile,
                          child: const Text("Update",style: TextStyle(color: AppColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),),
                        ),
                      )

                    ],
                  ),
                ),
              ),

              /// LOADER
              if(state.status == ProfileStatus.loading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )

            ],
          ),
        );
      },
    );
  }

  // ================= TEXTFIELD =================

  Widget buildTextField(
      String label,
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
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= DATE =================

  Widget buildDateField(){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: TextFormField(
        controller: dobController,
        readOnly: true,
        onTap: pickDate,

        validator: (v) =>
        v == null || v.isEmpty ? "Select DOB" : null,

        decoration: InputDecoration(
          labelText: "",
          suffixIcon: const Icon(Icons.calendar_today),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= RELATIONSHIP =================

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
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),

        onChanged: onChanged,

        validator: (v) => v == null ? "Select $label" : null,
      ),
    );
  }

  // ================= API DROPDOWN =================

  Widget buildDropdown({
    required String label,
    required String? value,
    required Map<String,String> items,
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

        items: items.entries.map((entry){

          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );

        }).toList(),

        onChanged: onChanged,

        validator: (v) => v == null ? "Select $label" : null,
      ),
    );
  }
}