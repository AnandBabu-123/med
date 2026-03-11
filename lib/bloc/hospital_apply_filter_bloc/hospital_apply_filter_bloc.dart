import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/hospital_repository/hospital_apply_filter_repository.dart';
import 'hospital_apply_filter_event.dart';
import 'hospital_apply_filter_state.dart';

class HospitalApplyFilterBloc
    extends Bloc<HospitalApplyFilterEvent, HospitalApplyFilterState> {

  final HospitalApplyFilterRepository repository;

  HospitalApplyFilterBloc(this.repository)
      : super(const HospitalApplyFilterState()) {

    on<ApplyHospitalFilterEvent>(_applyFilter);
  }

  Future<void> _applyFilter(
      ApplyHospitalFilterEvent event,
      Emitter<HospitalApplyFilterState> emit,
      ) async {

    print("=== APPLY FILTER EVENT TRIGGERED ===");

    emit(state.copyWith(loading: true));

    try {

      final result = await repository.hospitalApplyFilterData(
        language: event.language,
        lat: event.lat,
        lon: event.lon,
        subCatId: event.subCatId,
        subSubCatIds: event.subSubCatIds,
        page: event.page,
      );

      print("=== BLOC API RESULT ===");
      print("Status: ${result.status}");
      print("Hospitals Count: ${result.response.mainData.length}");

      for (var h in result.response.mainData) {
        print("Hospital Name: ${h.name}");
      }

      emit(state.copyWith(
        loading: false,
        hospitals: result.response.mainData,
        pagination: result.response.pagination,
      ));

    } catch (e) {

      print("=== APPLY FILTER ERROR ===");
      print(e.toString());

      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}