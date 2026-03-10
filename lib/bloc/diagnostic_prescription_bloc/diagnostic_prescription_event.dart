abstract class DiagnosticPrescriptionEvent {}

class UploadPrescriptionEvent extends DiagnosticPrescriptionEvent {

  final int diagnosticId;
  final String base64Image;
  final String name;
  final String mobile;
  final List<int> familyMemberId;
  final String language;

  UploadPrescriptionEvent({
    required this.diagnosticId,
    required this.base64Image,
    required this.name,
    required this.mobile,
    required this.familyMemberId,
    required this.language,
  });
}