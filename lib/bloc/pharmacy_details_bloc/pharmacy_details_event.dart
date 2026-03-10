abstract class PharmacyDetailsEvent {}

class FetchPharmacyDetails extends PharmacyDetailsEvent {
  final int pharmacyId;
  final String language;

  FetchPharmacyDetails({
    required this.pharmacyId,
    required this.language,
  });
}