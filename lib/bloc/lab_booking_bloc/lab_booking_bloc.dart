import 'package:bloc/bloc.dart';

import '../../repository/get_lab_test_repository/lab_test_booking_repository.dart';
import 'lab_booking_event.dart';
import 'lab_booking_state.dart';

class LabBookingBloc extends Bloc<LabBookingEvent, LabBookingState> {

  final LabTestBookingRepository repository;

  LabBookingBloc(this.repository) : super(LabBookingInitial()) {

    on<LoadDatesEvent>((event, emit) async {

      emit(LabBookingLoading());

      try {

        final data = await repository.labBookingRepository(

          labTestId: event.labTestId,
          testId: event.testId,
          fee: event.fee,
          viewType: "dates",
          date: "",

        );

        emit(DatesLoaded(data));

      } catch (e) {

        emit(LabBookingError(e.toString()));

      }

    });

    on<LoadSlotsEvent>((event, emit) async {

      emit(LabBookingLoading());

      try {

        final data = await repository.labBookingRepository(

          labTestId: event.labTestId,
          testId: event.testId,
          fee: event.fee,
          viewType: "slots",
          date: event.date,

        );

        emit(SlotsLoaded(data));

      } catch (e) {

        emit(LabBookingError(e.toString()));

      }

    });

  }
}