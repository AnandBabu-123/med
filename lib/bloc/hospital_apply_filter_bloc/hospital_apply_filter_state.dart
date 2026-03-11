
import '../../models/hospital_model/hospital_apply_filter_model.dart';

class HospitalApplyFilterState {

  final bool loading;
  final List<HospitalData> hospitals;
  final Pagination? pagination;
  final String error;

  const HospitalApplyFilterState({
    this.loading = false,
    this.hospitals = const [],
    this.pagination,
    this.error = "",
  });

  HospitalApplyFilterState copyWith({
    bool? loading,
    List<HospitalData>? hospitals,
    Pagination? pagination,
    String? error,
  }) {
    return HospitalApplyFilterState(
      loading: loading ?? this.loading,
      hospitals: hospitals ?? this.hospitals,
      pagination: pagination ?? this.pagination,
      error: error ?? this.error,
    );
  }
}