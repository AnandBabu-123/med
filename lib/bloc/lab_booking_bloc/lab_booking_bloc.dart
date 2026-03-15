import 'package:bloc/bloc.dart';
import '../../repository/get_lab_test_repository/lab_test_booking_repository.dart';
import 'lab_booking_event.dart';
import 'lab_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LabBookingBloc extends Bloc<LabBookingEvent, LabBookingState> {

  final LabTestBookingRepository repository;

  LabBookingBloc(this.repository) : super(const LabBookingState()) {

    on<FetchDatesEvent>(_fetchDates);
    on<FetchSlotsEvent>(_fetchSlots);
  }

  /// FETCH DATES
  Future<void> _fetchDates(
      FetchDatesEvent event,
      Emitter<LabBookingState> emit,
      ) async {

    emit(state.copyWith(isLoading: true));

    try {

      final response = await repository.labBookingRepository(
        labTestId: event.labTestId,
        testId: event.testId,
        fee: event.fee,
        viewType: "dates",
        date: "",
        familyMemberId: 0,
        count: 1,
      );

      print("===== DATEsss API RESPONSE =====");
      print(response);

      print("DATES FROM API: ${response.response.dates}");

      emit(
        state.copyWith(
          isLoading: false,
          dates: response.response.dates ?? [],
        ),
      );

    } catch (e) {

      print("DATE API ERROR: $e");

      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// FETCH SLOTS
  Future<void> _fetchSlots(
      FetchSlotsEvent event,
      Emitter<LabBookingState> emit,
      ) async {

    emit(state.copyWith(isLoading: true));

    try {

      final response = await repository.labBookingRepository(
        labTestId: event.labTestId,
        testId: event.testId,
        fee: event.fee,
        viewType: "slots",
        date: event.date,
        familyMemberId: 0,
        count: 1,
      );

      emit(
        state.copyWith(
          isLoading: false,
          slots: response.response.slots,
          familyMembers: response.response.familyMembers ?? [],
          prices: response.response.prices ?? [],
        ),
      );

    } catch (e) {

      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}