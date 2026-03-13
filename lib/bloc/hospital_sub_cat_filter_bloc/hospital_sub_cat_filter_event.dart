abstract class HospitalSubCatFilterEvent {}

class LoadHospitalSubCatFilterEvent extends HospitalSubCatFilterEvent {
  final String language;
  final String lat;
  final String lon;
  final int subCatId;
  final int page;

  LoadHospitalSubCatFilterEvent({
    required this.language,
    required this.lat,
    required this.lon,
    required this.subCatId,
    required this.page,
  });
}