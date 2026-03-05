// abstract class LabTestEvent {}
//
// class FetchLabTest extends LabTestEvent {
//   final String lat;
//   final String lon;
//   final String language;
//   final int page;
//   final String search;
//
//   FetchLabTest({
//     required this.lat,
//     required this.lon,
//     required this.language,
//     required this.page,
//     this.search = "",
//   });
// }

import 'package:equatable/equatable.dart';

abstract class LabTestEvent extends Equatable {
  const LabTestEvent();

  @override
  List<Object?> get props => [];
}

class FetchLabTest extends LabTestEvent {
  final String lat;
  final String lon;
  final String language;
  final int page;
  final String search;

  const FetchLabTest({
    required this.lat,
    required this.lon,
    required this.language,
    required this.page,
    this.search = "",
  });

  @override
  List<Object?> get props => [lat, lon, language, page, search];
}