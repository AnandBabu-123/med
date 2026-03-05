import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/diagnostic_repository/diagnostic_repository.dart';
import 'diagnostics_event.dart';
import 'diagnostics_state.dart';

class DiagnosticsBloc extends Bloc<DiagnosticsEvent, DiagnosticsState> {

  final GetDiagnosticRepository repository;

  DiagnosticsBloc(this.repository) : super(const DiagnosticsState()) {

    on<FetchDiagnostics>(_fetch);
  }

  Future<void> _fetch(
      FetchDiagnostics event,
      Emitter<DiagnosticsState> emit,
      ) async {

    try {

      ///  NEW SEARCH OR FIRST PAGE
      if (event.page == 1) {
        emit(state.copyWith(
          status: DiagnosticsStatus.loading,
          list: [],
          page: 1,
          hasReachedMax: false,
          search: event.search,
        ));
      }
      ///  STOP EXTRA PAGINATION CALLS
      else if (state.hasReachedMax) {
        return;
      }

      final response = await repository.getDiagnostics(
        lat: event.lat,
        lon: event.lon,
        language: event.language,
        page: event.page,
        search: event.search,
      );

      final fetchedList = response.mainData;

      final updatedList = event.page == 1
          ? fetchedList
          : [...state.list, ...fetchedList];

      emit(state.copyWith(
        status: DiagnosticsStatus.success,
        list: updatedList,
        page: event.page,
        hasReachedMax:
        fetchedList.isEmpty ||
            event.page >= response.pagination.totalPages,
      ));

    } catch (e, stack) {

      print("BLOC ERROR => $e");
      print(stack);

      emit(state.copyWith(
        status: DiagnosticsStatus.failure,
      ));
    }
  }
}