abstract class PharmacyOngoingOrdersEvent {}

class LoadOngoingOrders extends PharmacyOngoingOrdersEvent {
  final String language;
  final int page;

  LoadOngoingOrders({
    required this.language,
    required this.page,
  });
}