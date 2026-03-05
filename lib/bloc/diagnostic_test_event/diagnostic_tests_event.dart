abstract class DiagnosticTestsEvent {}

class FetchDiagnosticTests extends DiagnosticTestsEvent {

  final int diagnosticId;
  final int page;
  final String language;

  FetchDiagnosticTests({
    required this.diagnosticId,
    required this.page,
    required this.language,
  });
}