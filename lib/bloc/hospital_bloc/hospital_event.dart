import 'package:equatable/equatable.dart';

abstract class HospitalEvent extends Equatable {
  const HospitalEvent();

  @override
  List<Object?> get props => [];
}

class FetchHospitalsEvent extends HospitalEvent {
  final String lat;
  final String lon;
  final String language;
  final int page;
  final String search;
  final bool isPagination;

  const FetchHospitalsEvent({
    required this.lat,
    required this.lon,
    required this.language,
    this.page = 1,
    this.search = "",
    this.isPagination = false,
  });

  @override
  List<Object?> get props => [lat, lon, language, page, search, isPagination];
}