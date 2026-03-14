import 'package:bloc/bloc.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../repository/online_doctors_repository/online_doctor_dates_repository.dart';
import 'doctor_booking_event.dart';
import 'doctor_booking_state.dart';


class DoctorBookingBloc
    extends Bloc<DoctorBookingEvent, DoctorBookingState> {

  final OnlineDoctorDatesRepository repository;

  DoctorBookingBloc(this.repository) : super(DoctorBookingState()) {

    on<FetchDoctorDatesEvent>(_fetchDates);
    on<FetchDoctorSlotsEvent>(_fetchSlots);
  }

  /// FETCH DOCTOR DATES
  Future<void> _fetchDates(
      FetchDoctorDatesEvent event,
      Emitter<DoctorBookingState> emit) async {

    emit(state.copyWith(isLoading: true));

    try {

      final response = await repository.onlineDoctorsDates(
        language: event.language,
        specialityId: event.specialityId,
        doctorId: event.doctorId,
        fee: event.fee,
        viewType: "dates",
      );

      emit(
        state.copyWith(
          isLoading: false,
          dates: response.response?.dates ?? [],
        ),
      );

    } catch (e) {

      emit(state.copyWith(isLoading: false));
    }
  }

  /// FETCH DOCTOR SLOTS
  Future<void> _fetchSlots(
      FetchDoctorSlotsEvent event,
      Emitter<DoctorBookingState> emit) async {

    emit(state.copyWith(isLoading: true));

    try {

      final response = await repository.onlineDoctorsDates(
        language: event.language,
        specialityId: event.specialityId,
        doctorId: event.doctorId,
        fee: event.fee,
        viewType: "slots",
        date: event.date,
      );

      emit(
        state.copyWith(
          isLoading: false,
          slots: response.response!.slots,
          familyMembers: response.response?.familyMembers ?? [],
        ),
      );

    } catch (e) {

      emit(state.copyWith(isLoading: false));
    }
  }
}