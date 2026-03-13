import 'package:equatable/equatable.dart';
import 'package:medryder/models/online_doctors_model/online_doctors_model.dart';

import '../../models/online_doctors_model/online_doctor_speciality_model.dart';

class OnlineDoctorSpecialityState extends Equatable {

  final bool isLoading;
  final bool isDoctorsLoading;
  final bool isPaginationLoading;

  final List<Speciality> specialities;
  final List<Doctor> doctors;

  final int? selectedSpecialityId;

  final int currentPage;
  final bool hasMorePages;

  final String? error;

  const OnlineDoctorSpecialityState({
    this.isLoading = false,
    this.isDoctorsLoading = false,
    this.isPaginationLoading = false,
    this.specialities = const [],
    this.doctors = const [],
    this.selectedSpecialityId,
    this.currentPage = 1,
    this.hasMorePages = true,
    this.error,
  });

  OnlineDoctorSpecialityState copyWith({
    bool? isLoading,
    bool? isDoctorsLoading,
    bool? isPaginationLoading,
    List<Speciality>? specialities,
    List<Doctor>? doctors,
    int? selectedSpecialityId,
    int? currentPage,
    bool? hasMorePages,
    String? error,
  }) {
    return OnlineDoctorSpecialityState(
      isLoading: isLoading ?? this.isLoading,
      isDoctorsLoading: isDoctorsLoading ?? this.isDoctorsLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      specialities: specialities ?? this.specialities,
      doctors: doctors ?? this.doctors,
      selectedSpecialityId: selectedSpecialityId ?? this.selectedSpecialityId,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isDoctorsLoading,
    isPaginationLoading,
    specialities,
    doctors,
    selectedSpecialityId,
    currentPage,
    hasMorePages,
    error,
  ];
}