import '../../models/lab_test_models/lab_booking_model.dart';

class LabBookingState {

  final bool isLoading;
  final List<LabDate> dates;
  final Slots? slots;
  final List<FamilyMembers> familyMembers;
  final List<Prices> prices;
  final String? error;

  const LabBookingState({
    this.isLoading = false,
    this.dates = const [],
    this.slots,
    this.familyMembers = const [],
    this.prices = const [],
    this.error,
  });

  LabBookingState copyWith({
    bool? isLoading,
    List<LabDate>? dates,
    Slots? slots,
    List<FamilyMembers>? familyMembers,
    List<Prices>? prices,
    String? error,
  }) {
    return LabBookingState(
      isLoading: isLoading ?? this.isLoading,
      dates: dates ?? this.dates,
      slots: slots ?? this.slots,
      familyMembers: familyMembers ?? this.familyMembers,
      prices: prices ?? this.prices,
      error: error ?? this.error,
    );
  }
}