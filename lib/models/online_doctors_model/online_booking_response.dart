class OnlineDoctorBookingResponse {
  final bool status;
  final String message;
  final BookingResponse response;

  OnlineDoctorBookingResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory OnlineDoctorBookingResponse.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorBookingResponse(
      status: json['status'],
      message: json['message'],
      response: BookingResponse.fromJson(json['response']),
    );
  }
}

class BookingResponse {
  final List<DoctorDate>? dates;
  final Slots? slots;
  final List<FamilyMember>? familyMembers;

  BookingResponse({
    this.dates,
    this.slots,
    this.familyMembers,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      dates: json['dates'] != null
          ? (json['dates'] as List)
          .map((e) => DoctorDate.fromJson(e))
          .toList()
          : null,
      slots: json['slots'] != null
          ? Slots.fromJson(json['slots'])
          : null,
      familyMembers: json['family_members'] != null
          ? (json['family_members'] as List)
          .map((e) => FamilyMember.fromJson(e))
          .toList()
          : null,
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
      id: json['id'],
      time: json['time'],
      session: json['session'],
      bookingStatus: json['booking_status'],
      date: json['date'],
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
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}