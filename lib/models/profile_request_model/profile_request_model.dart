class ProfileRequestModel {

  final int userId;
  final String authToken;
  final String name;
  final String mobile;
  final String email;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String coverageCategory;
  final String relationship;
  final String image;

  ProfileRequestModel({
    required this.userId,
    required this.authToken,
    required this.name,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.coverageCategory,
    required this.relationship,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "auth_token": authToken,
      "name": name,
      "mobile": mobile,
      "email": email,
      "dob": dob,
      "gender": gender,
      "blood_group": bloodGroup,
      "coverage_category": coverageCategory,
      "relationship": relationship,
      "image": image,
    };
  }
}