import 'package:equatable/equatable.dart';

import '../../models/hospital_model/hospital_model.dart';


class HospitalState extends Equatable {

  final bool loading;
  final bool paginationLoading;
  final List<Hospital> hospitals;
  final String error;
  final int page;
  final bool hasReachedMax;

  const HospitalState({
    this.loading = false,
    this.paginationLoading = false,
    this.hospitals = const [],
    this.error = "",
    this.page = 1,
    this.hasReachedMax = false,
  });

  HospitalState copyWith({
    bool? loading,
    bool? paginationLoading,
    List<Hospital>? hospitals,
    String? error,
    int? page,
    bool? hasReachedMax,
  }) {
    return HospitalState(
      loading: loading ?? this.loading,
      paginationLoading: paginationLoading ?? this.paginationLoading,
      hospitals: hospitals ?? this.hospitals,
      error: error ?? this.error,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props =>
      [loading, paginationLoading, hospitals, error, page, hasReachedMax];
}