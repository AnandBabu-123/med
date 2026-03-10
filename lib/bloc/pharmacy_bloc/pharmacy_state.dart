import '../../models/pharmacy_model/pharmacy_category_model.dart';

enum PharmacyStatus { initial, loading, success, failure }

class PharmacyState {

  final PharmacyStatus status;
  final List<PharmacyModel> categories;
  final String message;
  final int page;
  final bool hasReachedMax;

  const PharmacyState({
    this.status = PharmacyStatus.initial,
    this.categories = const [],
    this.message = "",
    this.page = 1,
    this.hasReachedMax = false,
  });

  PharmacyState copyWith({
    PharmacyStatus? status,
    List<PharmacyModel>? categories,
    String? message,
    int? page,
    bool? hasReachedMax,
  }) {
    return PharmacyState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message ?? this.message,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}