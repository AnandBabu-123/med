import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/lab_bloc/lab_event.dart';
import 'package:medryder/bloc/lab_bloc/lab_state.dart';
import 'package:medryder/repository/get_lab_test_repository/lab_repository.dart';

class LabBloc extends Bloc<LabEvent, LabState> {

  final LabRepository repository;

  LabBloc(this.repository) : super(const LabState()) {

    on<FetchLabTests>(_fetchLabTests);
  }

  Future<void> _fetchLabTests(
      FetchLabTests event,
      Emitter<LabState> emit,
      ) async {

    try {

      emit(state.copyWith(status: LabStatus.loading));

      final response = await repository.LabTests(
        labTestId: event.labTestId,
        page: 1,
        language: "en",
      );

      emit(
        state.copyWith(
          status: LabStatus.success,
          packages: response.response.mainData,
        ),
      );

    } catch (e) {

      emit(state.copyWith(status: LabStatus.failure));

    }
  }
}