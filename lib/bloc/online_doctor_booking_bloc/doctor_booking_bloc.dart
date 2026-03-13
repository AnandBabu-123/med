import 'package:bloc/bloc.dart';
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

  Future<void> _fetchDates(
      FetchDoctorDatesEvent event,
      Emitter<DoctorBookingState> emit) async {

    emit(state.copyWith(isLoading: true));

    final response = await repository.onlineDoctorsDates(
      language: event.language,
      specialityId: event.specialityId,
      viewType: "dates",
    );

    emit(
      state.copyWith(
        isLoading: false,
        dates: response.response.dates ?? [],
      ),
    );
  }

  Future<void> _fetchSlots(
      FetchDoctorSlotsEvent event,
      Emitter<DoctorBookingState> emit) async {

    emit(state.copyWith(isLoading: true));

    final response = await repository.onlineDoctorsDates(
      language: event.language,
      specialityId: event.specialityId,
      viewType: "slots",
      date: event.date,
    );

    emit(
      state.copyWith(
        isLoading: false,
        slots: response.response.slots,
      ),
    );
  }
}