import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/hospital_repository/hospital_repository.dart';
import 'hospital_event.dart';
import 'hospital_state.dart';



class HospitalBloc extends Bloc<HospitalEvent, HospitalState> {

  final HospitalRepository repository;

  HospitalBloc(this.repository) : super(const HospitalState()) {

    on<FetchHospitalsEvent>(_fetchHospitals);
  }

  Future<void> _fetchHospitals(
      FetchHospitalsEvent event,
      Emitter<HospitalState> emit,
      ) async {

    try {

      if (event.isPagination) {
        if (state.hasReachedMax) return;

        emit(state.copyWith(paginationLoading: true));
      } else {
        emit(state.copyWith(loading: true, hospitals: []));
      }

      final response = await repository.pharmacyOngoingOrders(
        language: event.language,
        page: event.page,
        lat: event.lat,
        lon: event.lon,
        search: event.search,
      );

      print("===== BLOC RESPONSE =====");
      print(response);

      final newHospitals = response.response?.mainData ?? [];

      if (event.isPagination) {

        emit(state.copyWith(
          paginationLoading: false,
          hospitals: [...state.hospitals, ...newHospitals],
          page: state.page + 1,
          hasReachedMax: newHospitals.isEmpty,
        ));

      } else {

        emit(state.copyWith(
          loading: false,
          hospitals: newHospitals,
          page: 2,
          hasReachedMax: newHospitals.isEmpty,
        ));

      }

    } catch (e) {

      emit(state.copyWith(
        loading: false,
        paginationLoading: false,
        error: e.toString(),
      ));

    }
  }
}