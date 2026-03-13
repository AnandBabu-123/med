class HospitalFilterModel {
  final bool status;
  final String message;
  final HospitalFilterResponse response;

  HospitalFilterModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory HospitalFilterModel.fromJson(Map<String, dynamic> json) {
    return HospitalFilterModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      response: HospitalFilterResponse.fromJson(json['response'] ?? {}),
    );
  }
}

class HospitalFilterResponse {
  final List<HospitalCategory> details;

  HospitalFilterResponse({required this.details});

  factory HospitalFilterResponse.fromJson(Map<String, dynamic> json) {
    return HospitalFilterResponse(
      details: (json['details'] as List? ?? [])
          .map((e) => HospitalCategory.fromJson(e))
          .toList(),
    );
  }
}

class HospitalCategory {
  final int categoryId;
  final String categoryName;
  final List<Speciality> specialities;

  HospitalCategory({
    required this.categoryId,
    required this.categoryName,
    required this.specialities,
  });

  factory HospitalCategory.fromJson(Map<String, dynamic> json) {
    return HospitalCategory(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      specialities: (json['specialities'] as List? ?? [])
          .map((e) => Speciality.fromJson(e))
          .toList(),
    );
  }
}

class Speciality {
  final int specialityId;
  final String specialityName;
  final String specialityImage;

  Speciality({
    required this.specialityId,
    required this.specialityName,
    required this.specialityImage
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      specialityId: json['speciality_id'] ?? 0,
      specialityName: json['speciality_name'] ?? '',
      specialityImage: json['speciality_image'] ?? '',

    );
  }
}