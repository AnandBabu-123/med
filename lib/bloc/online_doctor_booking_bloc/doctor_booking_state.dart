import '../../models/online_doctors_model/online_booking_response.dart';

class DoctorBookingState {

  final bool isLoading;
  final List<DoctorDate> dates;
  final SlotSessions? slots;
  final List<FamilyMember> familyMembers;

  DoctorBookingState({
    this.isLoading = false,
    this.dates = const [],
    this.slots,
    this.familyMembers = const [],
  });

  DoctorBookingState copyWith({
    bool? isLoading,
    List<DoctorDate>? dates,
    SlotSessions? slots,
    List<FamilyMember>? familyMembers,
  }) {
    return DoctorBookingState(
      isLoading: isLoading ?? this.isLoading,
      dates: dates ?? this.dates,
      slots: slots ?? this.slots,
      familyMembers: familyMembers ?? this.familyMembers,
    );
  }
}