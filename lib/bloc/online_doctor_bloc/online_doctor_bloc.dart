import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/online_doctors_model/online_doctors_model.dart';
import '../../models/online_doctors_model/online_doctors_model.dart' as doctor;
import '../../repository/online_doctors_repository/online_doctor_repository.dart';
import 'online_doctor_event.dart';
import 'online_doctor_state.dart';



class OnlineDoctorBloc extends Bloc<OnlineDoctorEvent, OnlineDoctorState> {

  final OnlineDoctorRepository repository;

  OnlineDoctorBloc(this.repository) : super(OnlineDoctorState()) {
    on<FetchOnlineDoctorsEvent>(_fetchDoctors);
  }

  Future<void> _fetchDoctors(
      FetchOnlineDoctorsEvent event,
      Emitter<OnlineDoctorState> emit,
      ) async {

    emit(state.copyWith(isLoading: true, error: ""));

    try {

      final response = await repository.onlineDoctors(
        language: event.language,
      );

      final List<Speciality> list = response.response.specialities;

      emit(
        state.copyWith(
          isLoading: false,
          specialities: list,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );

    }
  }
}