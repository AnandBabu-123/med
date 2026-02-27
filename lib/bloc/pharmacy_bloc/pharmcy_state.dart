import '../../models/pharmacy_model/pharmacy_category_model.dart';

enum PharmacyStatus { initial, loading, success, failure }

class PharmacyState {
  final PharmacyStatus status;
  final List<PharmacyCategoryModel> categories;
  final String message;

  const PharmacyState({
    this.status = PharmacyStatus.initial,
    this.categories = const [],
    this.message = "",
  });

  PharmacyState copyWith({
    PharmacyStatus? status,
    List<PharmacyCategoryModel>? categories,
    String? message,
  }) {
    return PharmacyState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message ?? this.message,
    );
  }
}