import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/diagnostic_tests_repository/diagnostic_tests_repository.dart';
import 'diagnostic_tests_event.dart';
import 'diagnostic_tests_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'diagnostic_tests_event.dart';
import 'diagnostic_tests_state.dart';

class DiagnosticTestsBloc
    extends Bloc<DiagnosticTestsEvent, DiagnosticTestsState> {

  final DiagnosticTestsRepository repository;

  DiagnosticTestsBloc(this.repository)
      : super(const DiagnosticTestsState()) {

    on<FetchDiagnosticTests>(_fetchTests);
  }

  Future<void> _fetchTests(
      FetchDiagnosticTests event,
      Emitter<DiagnosticTestsState> emit,
      ) async {

    emit(state.copyWith(status: DiagnosticTestsStatus.loading));

    try {

      final list = await repository.getDiagnosticTests(
        diagnosticId: event.diagnosticId,
        page: event.page,
        language: event.language,
      );

      emit(
        state.copyWith(
          status: DiagnosticTestsStatus.success,
          list: list,
        ),
      );

    } catch (e) {

      emit(state.copyWith(status: DiagnosticTestsStatus.failure));

    }
  }
}