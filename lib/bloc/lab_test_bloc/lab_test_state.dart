// import 'package:medryder/models/lab_test_models/lab_test_model.dart';
//
// enum LabTestStatus { initial, loading, success, failure }
//
// class LabTestState {
//
//   final LabTestStatus status;
//   final List<LabMainData> list;
//   final int page;
//   final bool hasReachedMax;
//   final String search;
//
//   const LabTestState({
//     this.status = LabTestStatus.initial,
//     this.list = const [],
//     this.page = 1,
//     this.hasReachedMax = false,
//     this.search = "",
//   });
//
//   LabTestState copyWith({
//     LabTestStatus? status,
//     List<LabMainData>? list,
//     int? page,
//     bool? hasReachedMax,
//     String? search,
//   }) {
//     return LabTestState(
//       status: status ?? this.status,
//       list: list ?? this.list,
//       page: page ?? this.page,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//       search: search ?? this.search,
//     );
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:medryder/models/lab_test_models/lab_test_model.dart';

enum LabTestStatus { initial, loading, success, failure }

class LabTestState extends Equatable {

  final LabTestStatus status;
  final List<LabMainData> list;
  final int page;
  final bool hasReachedMax;
  final String search;

  const LabTestState({
    this.status = LabTestStatus.initial,
    this.list = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.search = "",
  });

  LabTestState copyWith({
    LabTestStatus? status,
    List<LabMainData>? list,
    int? page,
    bool? hasReachedMax,
    String? search,
  }) {
    return LabTestState(
      status: status ?? this.status,
      list: list ?? this.list,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [status, list, page, hasReachedMax, search,];
}