import 'package:bloc/bloc.dart';

import '../../repository/hospital_repository/hospital_sub_cat_filter_repository.dart';
import 'hospital_sub_cat_filter_event.dart';
import 'hospital_sub_cat_filter_state.dart';

class HospitalSubCatFilterBloc
    extends Bloc<HospitalSubCatFilterEvent, HospitalSubCatFilterState> {

  final HospitalSubCatFilterRepository repository;

  HospitalSubCatFilterBloc(this.repository)
      : super(HospitalSubCatFilterState()) {

    on<LoadHospitalSubCatFilterEvent>(_loadHospitals);
  }

  Future<void> _loadHospitals(
      LoadHospitalSubCatFilterEvent event,
      Emitter<HospitalSubCatFilterState> emit,
      ) async {

    emit(state.copyWith(loading: true));

    try {

      final response = await repository.hospitalSubCatFilterData(
        language: event.language,
        lat: event.lat,
        lon: event.lon,
        subCatId: event.subCatId,
        page: event.page,
      );

      emit(
        state.copyWith(
          loading: false,
          hospitals: response["response"] ?? [],
        ),
      );
    } catch (e) {

      print("SUB CAT FILTER ERROR: $e");

      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }
}