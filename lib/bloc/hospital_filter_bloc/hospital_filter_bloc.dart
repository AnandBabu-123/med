import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/hospital_repository/hospital_filter_repository.dart';
import 'hospital_filter_event.dart';
import 'hospital_filter_state.dart';

class HospitalFilterBloc
    extends Bloc<HospitalFilterEvent, HospitalFilterState> {

  final HospitalFilterRepository repository;

  HospitalFilterBloc(this.repository) : super(const HospitalFilterState()) {

    on<LoadHospitalFilter>(_loadHospitalFilter);
    on<ChangeCategory>(_changeCategory);
    on<ToggleSpeciality>(_toggleSpeciality);
    on<ResetFilters>(_resetFilters);
  }

  Future<void> _loadHospitalFilter(
      LoadHospitalFilter event,
      Emitter<HospitalFilterState> emit,
      ) async {

    emit(state.copyWith(loading: true));

    try {

      final result = await repository.hospitalFilterData(
        language: event.language,
      );

      emit(state.copyWith(
        loading: false,
        categories: result.response.details,
      ));

    } catch (e) {

      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }

  void _changeCategory(
      ChangeCategory event,
      Emitter<HospitalFilterState> emit,
      ) {

    emit(state.copyWith(
      selectedCategoryIndex: event.index,
    ));
  }

  void _toggleSpeciality(
      ToggleSpeciality event,
      Emitter<HospitalFilterState> emit,
      ) {

    final selected = List<int>.from(state.selectedSpecialities);

    if (selected.contains(event.specialityId)) {
      selected.remove(event.specialityId);
    } else {
      selected.add(event.specialityId);
    }

    emit(state.copyWith(selectedSpecialities: selected));
  }

  void _resetFilters(
      ResetFilters event,
      Emitter<HospitalFilterState> emit,
      ) {

    emit(state.copyWith(
      selectedSpecialities: [],
    ));
  }
}