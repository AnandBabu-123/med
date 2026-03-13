import '../../models/online_doctors_model/online_booking_response.dart';

class DoctorBookingState {

  final bool isLoading;
  final List<DoctorDate> dates;
  final Slots? slots;

  DoctorBookingState({
    this.isLoading = false,
    this.dates = const [],
    this.slots,
  });

  DoctorBookingState copyWith({
    bool? isLoading,
    List<DoctorDate>? dates,
    Slots? slots,
  }) {
    return DoctorBookingState(
      isLoading: isLoading ?? this.isLoading,
      dates: dates ?? this.dates,
      slots: slots ?? this.slots,
    );
  }
}