import '../../models/pharmacy_model/pharmacy_ongoing_orders_model.dart';

class PharmacyOngoingOrdersState {

  final bool isLoading;
  final List<OrderItem> orders;
  final bool hasReachedMax;
  final int page;

  PharmacyOngoingOrdersState({
    this.isLoading = false,
    this.orders = const [],
    this.hasReachedMax = false,
    this.page = 1,
  });

  PharmacyOngoingOrdersState copyWith({
    bool? isLoading,
    List<OrderItem>? orders,
    bool? hasReachedMax,
    int? page,
  }) {
    return PharmacyOngoingOrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}