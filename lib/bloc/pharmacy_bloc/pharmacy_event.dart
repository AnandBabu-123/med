abstract class PharmacyEvent {}

class FetchPharmacyCategories extends PharmacyEvent {
  final String language;

  FetchPharmacyCategories(this.language);
}