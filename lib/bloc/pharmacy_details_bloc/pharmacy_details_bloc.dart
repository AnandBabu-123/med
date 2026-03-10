import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/pharmacy_details_bloc/pharmacy_details_event.dart';
import 'package:medryder/bloc/pharmacy_details_bloc/pharmacy_details_state.dart';

import '../../models/pharmacy_model/pharmacy_category_model.dart';
import '../../repository/pharmacy_repository/pharmacy_details_repository.dart';

class PharmacyDetailsBloc
    extends Bloc<PharmacyDetailsEvent, PharmacyDetailsState> {

  final PharmacyDetailsRepository repository;

  PharmacyDetailsBloc(this.repository)
      : super(PharmacyDetailsState()) {

    on<FetchPharmacyDetails>(_fetchDetails);
  }

  Future<void> _fetchDetails(
      FetchPharmacyDetails event,
      Emitter<PharmacyDetailsState> emit,
      ) async {

    emit(state.copyWith(status: PharmacyDetailsStatus.loading));

    try {

      final response = await repository.getPharmacyDetails(
        mainDataId: event.pharmacyId,
        language: event.language,
      );

      emit(state.copyWith(
        status: PharmacyDetailsStatus.success,
          pharmacy: response.data,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: PharmacyDetailsStatus.failure,
        message: e.toString(),
      ));
    }
  }
}