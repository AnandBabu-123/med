abstract class DoctorBookingEvent {}

class FetchDoctorDatesEvent extends DoctorBookingEvent {
  final String language;
  final int specialityId;
  final int doctorId;
  final int fee;

  FetchDoctorDatesEvent({
    required this.language,
    required this.specialityId,
    required this.doctorId,
    required this.fee,
  });
}

class FetchDoctorSlotsEvent extends DoctorBookingEvent {
  final String language;
  final int specialityId;
  final int doctorId;
  final int fee;
  final String date;

  FetchDoctorSlotsEvent({
    required this.language,
    required this.specialityId,
    required this.doctorId,
    required this.fee,
    required this.date,
  });
}