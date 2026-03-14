class OnlineDoctorBookingResponse {
  final bool status;
  final String message;
  final BookingResponse? response;

  OnlineDoctorBookingResponse({
    required this.status,
    required this.message,
    this.response,
  });

  factory OnlineDoctorBookingResponse.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorBookingResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      response: json['response'] != null
          ? BookingResponse.fromJson(json['response'])
          : null,
    );
  }
}

class BookingResponse {
  final List<DoctorDate> dates;
  final SlotSessions? slots;
  final List<FamilyMember> familyMembers;

  BookingResponse({
    this.dates = const [],
    this.slots,
    this.familyMembers = const [],
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      dates: (json['dates'] as List? ?? [])
          .map((e) => DoctorDate.fromJson(e))
          .toList(),

      slots: json['slots'] != null
          ? SlotSessions.fromJson(json['slots'])
          : null,

      familyMembers: (json['family_members'] as List? ?? [])
          .map((e) => FamilyMember.fromJson(e))
          .toList(),
    );
  }
}

class DoctorDate {
  final String date;
  final String formatDate;
  final String convertDate;

  DoctorDate({
    required this.date,
    required this.formatDate,
    required this.convertDate,
  });

  factory DoctorDate.fromJson(Map<String, dynamic> json) {
    return DoctorDate(
      date: json['date'],
      formatDate: json['format_date'],
      convertDate: json['convert_date'],
    );
  }
}
class Slots {
  final int id;
  final String time;
  final String session;
  final String bookingStatus;
  final String date;

  Slots({
    required this.id,
    required this.time,
    required this.session,
    required this.bookingStatus,
    required this.date,
  });

  factory Slots.fromJson(Map<String, dynamic> json) {
    return Slots(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      time: json['time']?.toString() ?? "",
      session: json['session']?.toString() ?? "",
      bookingStatus: json['booking_status']?.toString() ?? "",
      date: json['date']?.toString() ?? "",
    );
  }
}
class FamilyMember {
  final int id;
  final String name;
  final String type;

  FamilyMember({
    required this.id,
    required this.name,
    required this.type,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? "",
      type: json['type']?.toString() ?? "",
    );
  }
}

class SlotSessions {
  final List<Slots> morning;
  final List<Slots> afternoon;
  final List<Slots> evening;

  SlotSessions({
    this.morning = const [],
    this.afternoon = const [],
    this.evening = const [],
  });

  factory SlotSessions.fromJson(Map<String, dynamic> json) {
    return SlotSessions(
      morning: (json['morning'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),

      afternoon: (json['afternoon'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),

      evening: (json['evening'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),
    );
  }
}
class SlotsResponse {

  final List<Slots> morning;
  final List<Slots> afternoon;
  final List<Slots> evening;

  SlotsResponse({
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory SlotsResponse.fromJson(Map<String, dynamic> json) {

    return SlotsResponse(

      morning: (json['morning'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),

      afternoon: (json['afternoon'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),

      evening: (json['evening'] as List? ?? [])
          .map((e) => Slots.fromJson(e))
          .toList(),
    );
  }
}