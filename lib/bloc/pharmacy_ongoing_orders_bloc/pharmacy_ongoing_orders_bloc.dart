import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/pharmacy_ongoing_orders_bloc/pharmacy_ongoing_orders_event.dart';
import 'package:medryder/bloc/pharmacy_ongoing_orders_bloc/pharmacy_ongoing_orders_state.dart';

import '../../models/pharmacy_model/pharmacy_ongoing_orders_model.dart';
import '../../repository/pharmacy_repository/pharmacy_orders_repository.dart';

class PharmacyOngoingOrdersBloc
    extends Bloc<PharmacyOngoingOrdersEvent, PharmacyOngoingOrdersState> {

  final PharmacyOrdersRepository repository;

  PharmacyOngoingOrdersBloc(this.repository) : super(PharmacyOngoingOrdersState()) {

    on<LoadOngoingOrders>(_loadOrders);
  }

  Future<void> _loadOrders(
      LoadOngoingOrders event,
      Emitter<PharmacyOngoingOrdersState> emit,
      ) async {

    if (state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    try {

      final result = await repository.pharmacyOngoingOrders(
        language: event.language,
        page: event.page,
      );

      final orders = result.response.orders;

      final updatedList = List<OrderItem>.from(state.orders)..addAll(orders);

      final totalPages =
          result.response.pagination.totalPages.last.page;

      emit(state.copyWith(
        isLoading: false,
        orders: updatedList,
        page: event.page,
        hasReachedMax: event.page >= totalPages,
      ));

    } catch (e) {

      emit(state.copyWith(isLoading: false));
    }
  }
}