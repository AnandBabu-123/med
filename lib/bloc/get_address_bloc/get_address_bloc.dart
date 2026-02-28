import 'package:bloc/bloc.dart';

import '../../repository/get_address_repository/get_address_repository.dart';
import 'get_address_event.dart';
import 'get_address_state.dart';

class GetAddressBloc
    extends Bloc<GetAddressEvent, GetAddressState> {

  final GetAddressRepository repository;

  GetAddressBloc(this.repository)
      : super(const GetAddressState()) {

    on<FetchAddressEvent>(_fetchAddresses);
  }

  Future<void> _fetchAddresses(
      FetchAddressEvent event,
      Emitter<GetAddressState> emit,
      ) async {

    emit(state.copyWith(status: GetAddressStatus.loading));

    try {
      final list = await repository.getAddresses();

      emit(state.copyWith(
        status: GetAddressStatus.success,
        addresses: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GetAddressStatus.failure,
        message: e.toString(),
      ));
    }
  }
}