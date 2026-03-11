import 'package:equatable/equatable.dart';

import '../../models/hospital_model/hospital_filter_model.dart';


class HospitalFilterState {

  final bool loading;
  final List<HospitalCategory> categories;
  final int selectedCategoryIndex;
  final List<int> selectedSpecialities;
  final String error;

  const HospitalFilterState({
    this.loading = false,
    this.categories = const [],
    this.selectedCategoryIndex = 0,
    this.selectedSpecialities = const [],
    this.error = "",
  });

  HospitalFilterState copyWith({
    bool? loading,
    List<HospitalCategory>? categories,
    int? selectedCategoryIndex,
    List<int>? selectedSpecialities,
    String? error,
  }) {
    return HospitalFilterState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      selectedCategoryIndex:
      selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedSpecialities:
      selectedSpecialities ?? this.selectedSpecialities,
      error: error ?? this.error,
    );
  }
}