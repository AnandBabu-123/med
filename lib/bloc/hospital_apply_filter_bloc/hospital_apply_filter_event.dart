abstract class HospitalApplyFilterEvent {}

class ApplyHospitalFilterEvent extends HospitalApplyFilterEvent {
  final String language;
  final String lat;
  final String lon;
  final int subCatId;
  final String subSubCatIds;
  final int page;

  ApplyHospitalFilterEvent({
    required this.language,
    required this.lat,
    required this.lon,
    required this.subCatId,
    required this.subSubCatIds,
    required this.page,
  });
}