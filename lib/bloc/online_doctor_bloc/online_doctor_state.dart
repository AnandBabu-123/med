
import '../../models/online_doctors_model/online_doctors_model.dart';

class OnlineDoctorState {

  final bool isLoading;
  final List<Speciality> specialities;
  final String error;

  OnlineDoctorState({
    this.isLoading = false,
    this.specialities = const [],
    this.error = "",
  });

  OnlineDoctorState copyWith({
    bool? isLoading,
    List<Speciality>? specialities,
    String? error,
  }) {
    return OnlineDoctorState(
      isLoading: isLoading ?? this.isLoading,
      specialities: specialities ?? this.specialities,
      error: error ?? this.error,
    );
  }
}