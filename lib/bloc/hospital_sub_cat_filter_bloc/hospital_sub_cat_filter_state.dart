class HospitalSubCatFilterState {

  final bool loading;
  final List hospitals;

  HospitalSubCatFilterState({
    this.loading = false,
    this.hospitals = const [],
  });

  HospitalSubCatFilterState copyWith({
    bool? loading,
    List? hospitals,
  }) {
    return HospitalSubCatFilterState(
      loading: loading ?? this.loading,
      hospitals: hospitals ?? this.hospitals,
    );
  }
}