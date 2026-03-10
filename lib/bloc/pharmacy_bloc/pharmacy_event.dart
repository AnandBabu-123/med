abstract class PharmacyEvent {}

class FetchPharmacyCategories extends PharmacyEvent {

  final String lat;
  final String lon;
  final String language;
  final int page;
  final String search;
  final bool isLoadMore;

  FetchPharmacyCategories({
    required this.lat,
    required this.lon,
    required this.language,
    this.page = 1,
    this.search = "",
    this.isLoadMore = false,
  });
}