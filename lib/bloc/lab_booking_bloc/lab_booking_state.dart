import '../../models/lab_test_models/lab_booking_model.dart';

abstract class LabBookingState {}

class LabBookingInitial extends LabBookingState {}

class LabBookingLoading extends LabBookingState {}

class DatesLoaded extends LabBookingState {

  final LabBookingModel model;

  DatesLoaded(this.model);
}

class SlotsLoaded extends LabBookingState {

  final LabBookingModel model;

  SlotsLoaded(this.model);
}

class LabBookingError extends LabBookingState {

  final String message;

  LabBookingError(this.message);
}