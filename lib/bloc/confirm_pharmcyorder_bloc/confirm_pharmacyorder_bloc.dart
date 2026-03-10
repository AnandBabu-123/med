import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/confirm_pharmcyorder_bloc/confirm_pharmacyorder_event.dart';
import 'package:medryder/bloc/confirm_pharmcyorder_bloc/confirm_pharmacyorder_state.dart';
import '../../repository/pharmacy_repository/confirm_address_repository.dart';
import '../../utils/session_manager.dart';

class ConfirmPharmacyOrderBloc extends Bloc<ConfirmPharmacyOrderEvent, ConfirmPharmacyOrderState> {

  final ConfirmAddressRepository repository;

  ConfirmPharmacyOrderBloc(this.repository) : super(ConfirmOrderPharmacyInitial()) {
    on<SubmitConfirmPharmacyOrderEvent>(_submitOrder);
  }

  Future<void> _submitOrder(
      SubmitConfirmPharmacyOrderEvent event,
      Emitter<ConfirmPharmacyOrderState> emit,
      ) async {

    try {

      emit(ConfirmOrderPharmacyLoading());

      final userId = await SessionManager.getUserId();
      final token = await SessionManager.getToken();

      final bytes = await event.file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await repository.getPharmacies(

        userId: userId!,
        token: token!,
        pharmacyId: event.pharmacyId,
        image: base64Image,
        orderType: event.orderType,
        addressId: event.addressId,
        name: event.name,
        mobile: event.mobile,
        language: event.language,
      );

      emit(ConfirmOrderPharmacySuccess(response["message"]));

    } catch (e) {

      emit(ConfirmOrderPharmacyError(e.toString()));

    }
  }
}