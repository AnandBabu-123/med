import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/online_doctor_speciality_bloc/online_doctor_speciality_event.dart';
import 'package:medryder/bloc/online_doctor_speciality_bloc/online_doctor_speciality_state.dart';

import '../../repository/online_doctors_repository/online_doctor_repository.dart';
import '../../repository/online_doctors_repository/online_doctor_speciality_repository.dart';



class OnlineDoctorSpecialityBloc
    extends Bloc<OnlineDoctorSpecialityEvent, OnlineDoctorSpecialityState> {

  final OnlineDoctorRepository specialityRepository;
  final OnlineDoctorSpecialityRepository doctorRepository;

  OnlineDoctorSpecialityBloc(
      this.specialityRepository,
      this.doctorRepository,
      ) : super(const OnlineDoctorSpecialityState()) {

    on<FetchOnlineDoctorsEvent>(_fetchSpecialities);
    on<FetchDoctorsBySpecialityEvent>(_fetchDoctors);
  }

  /// FETCH SPECIALITIES
  Future<void> _fetchSpecialities(
      FetchOnlineDoctorsEvent event,
      Emitter<OnlineDoctorSpecialityState> emit) async {

    emit(state.copyWith(isLoading: true));

    try {

      final response = await specialityRepository.onlineDoctors(
        language: event.language,
      );

      final list = response.response.specialities;

      if (list.isEmpty) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final firstId = list.first.id;

      emit(state.copyWith(
        isLoading: false,
        specialities: list,
        selectedSpecialityId: firstId,
      ));

      add(FetchDoctorsBySpecialityEvent(
        specialityId: firstId,
        language: event.language,
      ));

    } catch (e) {

      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// FETCH DOCTORS
  Future<void> _fetchDoctors(
      FetchDoctorsBySpecialityEvent event,
      Emitter<OnlineDoctorSpecialityState> emit) async {

    final page = event.isPagination ? state.currentPage + 1 : 1;

    if (event.isPagination) {
      emit(state.copyWith(isPaginationLoading: true));
    } else {
      emit(state.copyWith(isDoctorsLoading: true));
    }

    try {

      final response = await doctorRepository.onlineDoctorsSpeciality(
        language: event.language,
        specialityId: event.specialityId,
        page: page,
      );

      final newDoctors = response.response.doctors;

      final updatedDoctors = event.isPagination
          ? [...state.doctors, ...newDoctors]
          : newDoctors;

      final totalPages = response.response.pagination.totalPages.length;
      emit(state.copyWith(
        isDoctorsLoading: false,
        isPaginationLoading: false,
        doctors: updatedDoctors,
        selectedSpecialityId: event.specialityId,
        currentPage: page,
        hasMorePages: page < totalPages,
      ));

    } catch (e) {

      emit(state.copyWith(
        isDoctorsLoading: false,
        isPaginationLoading: false,
        error: e.toString(),
      ));
    }
  }
}