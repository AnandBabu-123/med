import '../../models/get_address/get_address_model.dart';

enum GetAddressStatus { initial, loading, success, failure }

class GetAddressState {
  final GetAddressStatus status;
  final List<AddressItem> addresses;
  final String message;

  const GetAddressState({
    this.status = GetAddressStatus.initial,
    this.addresses = const [],
    this.message = "",
  });

  GetAddressState copyWith({
    GetAddressStatus? status,
    List<AddressItem>? addresses,
    String? message,
  }) {
    return GetAddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      message: message ?? this.message,
    );
  }
}