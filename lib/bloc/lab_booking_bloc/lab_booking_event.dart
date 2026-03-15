abstract class LabBookingEvent {}

class FetchDatesEvent extends LabBookingEvent {
  final int labTestId;
  final int testId;
  final int fee;

  FetchDatesEvent({
    required this.labTestId,
    required this.testId,
    required this.fee,
  });
}

class FetchSlotsEvent extends LabBookingEvent {
  final int labTestId;
  final int testId;
  final int fee;
  final String date;

  FetchSlotsEvent({
    required this.labTestId,
    required this.testId,
    required this.fee,
    required this.date,
  });
}