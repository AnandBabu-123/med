class ProfileRequestModel {

  final String image;
  final int gender;
  final int coverageCategory;
  final int userId;
  final String dob;
  final String name;
  final int mobile;
  final int bloodGroup;
  final String email;

  ProfileRequestModel({
    required this.image,
    required this.gender,
    required this.coverageCategory,
    required this.userId,
    required this.dob,
    required this.name,
    required this.mobile,
    required this.bloodGroup,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name.trim(),
      "mobile": mobile,
      "email": email.trim(),
      "gender": gender,                 // ✅ INT
      "dob": dob,
      "blood_group": bloodGroup,        // ✅ INT
      "coverage_category": coverageCategory,
      "image": image,
    };
  }
}