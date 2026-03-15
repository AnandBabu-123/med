import 'package:bloc/bloc.dart';
import '../../repository/get_lab_test_repository/lab_test_booking_repository.dart';
import 'lab_booking_event.dart';
import 'lab_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LabBookingBloc extends Bloc<LabBookingEvent, LabBookingState> {

  final LabTestBookingRepository repository;

  LabBookingBloc(this.repository) : super(const LabBookingState()) {

    /// LOAD DATES
    on<LoadDatesEvent>((event, emit) async {

      emit(state.copyWith(isLoading: true, error: null));

      try {

        final data = await repository.labBookingRepository(
          labTestId: event.labTestId,
          testId: event.testId,
          fee: event.fee,
          viewType: "dates",
          date: "",
          familyMemberId: 562,
          count: 1,
        );

        emit(
          state.copyWith(
            isLoading: false,
            dates: data.response.dates ?? [],
            familyMembers: data.response.familyMembers ?? [],
            prices: data.response.prices ?? [],
            slots: null,
            error: null,
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
    });

    /// LOAD SLOTS
    on<LoadSlotsEvent>((event, emit) async {

      emit(state.copyWith(isLoading: true, error: null));

      try {

        final data = await repository.labBookingRepository(
          labTestId: event.labTestId,
          testId: event.testId,
          fee: event.fee,
          viewType: "slots",
          date: event.date,
          familyMemberId: 562,
          count: 1,
        );

        emit(
          state.copyWith(
            isLoading: false,
            slots: data.response.slots,
            error: null,
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
    });
  }
}