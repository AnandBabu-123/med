import '../../models/pharmacy_model/pharmacy_details_model.dart';

enum PharmacyDetailsStatus { initial, loading, success, failure }

class PharmacyDetailsState {

  final PharmacyDetailsStatus status;
  final PharmacyData? pharmacy;
  final String message;

  const PharmacyDetailsState({
    this.status = PharmacyDetailsStatus.initial,
    this.pharmacy,
    this.message = "",
  });

  PharmacyDetailsState copyWith({
    PharmacyDetailsStatus? status,
    PharmacyData? pharmacy,
    String? message,
  }) {
    return PharmacyDetailsState(
      status: status ?? this.status,
      pharmacy: pharmacy ?? this.pharmacy,
      message: message ?? this.message,
    );
  }
}