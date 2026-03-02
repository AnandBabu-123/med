abstract class LabTestEvent {}

class FetchLabTest extends LabTestEvent {
  final String lat;
  final String lon;
  final String language;
  final int page;
  final String search;

  FetchLabTest({
    required this.lat,
    required this.lon,
    required this.language,
    required this.page,
    this.search = "",
  });
}