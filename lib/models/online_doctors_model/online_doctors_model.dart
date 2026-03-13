class OnlineDoctorsModel {
  final bool status;
  final String message;
  final OnlineDoctorsResponse response;

  OnlineDoctorsModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory OnlineDoctorsModel.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      response: OnlineDoctorsResponse.fromJson(json['response'] ?? {}),
    );
  }
}

class OnlineDoctorsResponse {
  final List<Speciality> specialities;

  OnlineDoctorsResponse({
    required this.specialities,
  });

  factory OnlineDoctorsResponse.fromJson(Map<String, dynamic> json) {
    final List<Speciality> list =
    (json['specialities'] as List<dynamic>? ?? [])
        .map((e) => Speciality.fromJson(e as Map<String, dynamic>))
        .toList();

    return OnlineDoctorsResponse(
      specialities: list,
    );
  }
}

class Speciality {
  final int id;
  final String name;
  final String image;

  Speciality({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}