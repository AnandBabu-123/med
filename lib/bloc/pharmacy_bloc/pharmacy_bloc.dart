import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/pharmacy_bloc/pharmacy_event.dart';
import 'package:medryder/bloc/pharmacy_bloc/pharmacy_state.dart';

import '../../repository/pharmacy_repository/pharmacy_repository.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {

  final PharmacyRepository repository;

  PharmacyBloc(this.repository) : super(const PharmacyState()) {

    on<FetchPharmacyCategories>(_fetch);
  }

  Future<void> _fetch(
      FetchPharmacyCategories event,
      Emitter<PharmacyState> emit,
      ) async {

    try {

      if (!event.isLoadMore) {
        emit(state.copyWith(status: PharmacyStatus.loading));
      }

      final response = await repository.getPharmacies(
        lat: event.lat,
        lon: event.lon,
        language: event.language,
        page: event.page,
        search: event.search,
      );

      final newList = response.response.mainData;

      if (event.isLoadMore) {

        emit(
          state.copyWith(
            status: PharmacyStatus.success,
            categories: List.of(state.categories)..addAll(newList),
            page: event.page,
            hasReachedMax: newList.isEmpty,
          ),
        );

      } else {

        emit(
          state.copyWith(
            status: PharmacyStatus.success,
            categories: newList,
            page: 1,
            hasReachedMax: false,
          ),
        );
      }

    } catch (e) {

      emit(
        state.copyWith(
          status: PharmacyStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}