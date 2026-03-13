abstract class OnlineDoctorEvent {}

class FetchOnlineDoctorsEvent extends OnlineDoctorEvent {
  final String language;

  FetchOnlineDoctorsEvent({required this.language});
}