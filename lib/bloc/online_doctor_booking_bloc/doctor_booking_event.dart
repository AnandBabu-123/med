abstract class DoctorBookingEvent {}

class FetchDoctorDatesEvent extends DoctorBookingEvent {
  final String language;
  final int specialityId;

  FetchDoctorDatesEvent({
    required this.language,
    required this.specialityId,
  });
}

class FetchDoctorSlotsEvent extends DoctorBookingEvent {
  final String language;
  final int specialityId;
  final String date;

  FetchDoctorSlotsEvent({
    required this.language,
    required this.specialityId,
    required this.date,
  });
}