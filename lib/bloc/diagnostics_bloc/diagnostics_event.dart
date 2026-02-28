

abstract class DiagnosticsEvent {}

class FetchDiagnostics extends DiagnosticsEvent {
  final String lat;
  final String lon;
  final String language;
  final int page;
  final String search;

  FetchDiagnostics({
    required this.lat,
    required this.lon,
    required this.language,
    required this.page,
    this.search = "",
  });
}