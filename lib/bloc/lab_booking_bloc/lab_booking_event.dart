abstract class LabBookingEvent {}

class LoadDatesEvent extends LabBookingEvent {
  final int labTestId;
  final int testId;
  final int fee;

  LoadDatesEvent(this.labTestId, this.testId, this.fee);
}

class LoadSlotsEvent extends LabBookingEvent {
  final int labTestId;
  final int testId;
  final int fee;
  final String date;

  LoadSlotsEvent(
      this.labTestId,
      this.testId,
      this.fee,
      this.date,
      );
}