import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/lab_test_bloc/lab_test_event.dart';
import 'package:medryder/bloc/lab_test_bloc/lab_test_state.dart';
import 'package:medryder/repository/get_lab_test_repository/lab_test_repository.dart';

class LabTestBloc
    extends Bloc<LabTestEvent, LabTestState> {

  final LabTestRepository repository;

  LabTestBloc(this.repository)
      : super(const LabTestState()) {

    on<FetchLabTest>(_fetch);
  }

  Future<void> _fetch(
      FetchLabTest event,
      Emitter<LabTestState> emit,
      ) async {
    try {

      /// FIRST LOAD / SEARCH
      if (event.page == 1) {
        emit(state.copyWith(
          status: LabTestStatus.loading,
          list: [],
          page: 1,
          hasReachedMax: false,
          search: event.search,
        ));
      } else if (state.hasReachedMax) {
        return;
      }

      final response = await repository.getLabTest(
        lat: event.lat,
        lon: event.lon,
        language: event.language,
        page: event.page,
        search: event.search,
      );

      /// ✅ GET LIST FROM MODEL
      final fetchedList = response.response.mainData;

      final updatedList = event.page == 1
          ? fetchedList
          : [...state.list, ...fetchedList];

      /// ✅ pagination page extraction
      final totalPages =
          response.response.pagination.totalPages.last;

      emit(state.copyWith(
        status: LabTestStatus.success,
        list: updatedList,
        page: event.page,
        hasReachedMax:
        fetchedList.isEmpty || event.page >= totalPages,
      ));
    } catch (e) {
      emit(state.copyWith(status: LabTestStatus.failure));
    }
  }
}