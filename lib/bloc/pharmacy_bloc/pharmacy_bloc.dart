import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/pharmacy_bloc/pharmcy_event.dart';
import 'package:medryder/bloc/pharmacy_bloc/pharmcy_state.dart';

import '../../repository/pharmacy_repository/pharmacy_repository.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {

  final PharmacyRepository repository;

  PharmacyBloc(this.repository)
      : super(const PharmacyState()) {

    on<FetchPharmacyCategories>(_fetch);
  }

  Future<void> _fetch(
      FetchPharmacyCategories event,
      Emitter<PharmacyState> emit) async {

    try {
      emit(state.copyWith(status: PharmacyStatus.loading));

      final data =
      await repository.fetchCategories(event.language);

      emit(state.copyWith(
        status: PharmacyStatus.success,
        categories: data,
      ));

    } catch (e) {
      emit(state.copyWith(
        status: PharmacyStatus.failure,
        message: e.toString(),
      ));
    }
  }
}