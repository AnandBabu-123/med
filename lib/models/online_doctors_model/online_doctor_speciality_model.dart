import 'package:equatable/equatable.dart';

class OnlineDoctorSpecialityModel extends Equatable {
  final bool status;
  final String message;
  final OnlineDoctorSpecialityResponse response;

  const OnlineDoctorSpecialityModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory OnlineDoctorSpecialityModel.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorSpecialityModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      response: OnlineDoctorSpecialityResponse.fromJson(json['response'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [status, message, response];
}

class OnlineDoctorSpecialityResponse extends Equatable {
  final List<Doctor> doctors;
  final Pagination pagination;

  const OnlineDoctorSpecialityResponse({
    required this.doctors,
    required this.pagination,
  });

  factory OnlineDoctorSpecialityResponse.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorSpecialityResponse(
      doctors: (json['doctors'] as List? ?? [])
          .map((e) => Doctor.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [doctors, pagination];
}

class Doctor extends Equatable {
  final int id;
  final String uniqueId;
  final int specialityId;
  final String name;
  final String image;
  final String qualification;
  final String specialization;
  final String exp;
  final String description;
  final int fee;
  final String rating;
  final int totalReviews;
  final int consultations;

  const Doctor({
    required this.id,
    required this.uniqueId,
    required this.specialityId,
    required this.name,
    required this.image,
    required this.qualification,
    required this.specialization,
    required this.exp,
    required this.description,
    required this.fee,
    required this.rating,
    required this.totalReviews,
    required this.consultations,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      uniqueId: json['unique_id']?.toString() ?? '',
      specialityId: json['speciality_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      qualification: json['qualification'] ?? '',
      specialization: json['specialization'] ?? '',
      exp: json['exp']?.toString() ?? '',
      description: json['description'] ?? '',
      fee: json['fee'] ?? 0,
      rating: json['rating']?.toString() ?? '0.0',
      totalReviews: json['total_reviews'] ?? 0,
      consultations: json['consultations'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    uniqueId,
    specialityId,
    name,
    image,
    qualification,
    specialization,
    exp,
    description,
    fee,
    rating,
    totalReviews,
    consultations,
  ];
}

class Pagination extends Equatable {
  final List<TotalPage> totalPages;
  final int currentPage;
  final int limit;

  const Pagination({
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: (json['total_pages'] as List? ?? [])
          .map((e) => TotalPage.fromJson(e))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }

  @override
  List<Object?> get props => [totalPages, currentPage, limit];
}

class TotalPage extends Equatable {
  final int page;

  const TotalPage({required this.page});

  factory TotalPage.fromJson(Map<String, dynamic> json) {
    return TotalPage(
      page: json['page'] ?? 1,
    );
  }

  @override
  List<Object?> get props => [page];
}