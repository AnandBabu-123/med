class LabBookingModel {
  final bool status;
  final String message;
  final LabBookingResponse response;

  LabBookingModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LabBookingModel.fromJson(Map<String, dynamic> json) {
    return LabBookingModel(
      status: json["status"],
      message: json["message"],
      response: LabBookingResponse.fromJson(json["response"]),
    );
  }
}
class LabBookingResponse {

  final List<LabDate>? dates;
  final Slots? slots;
  final List<FamilyMember>? familyMembers;
  final List<Price>? prices;

  LabBookingResponse({
    this.dates,
    this.slots,
    this.familyMembers,
    this.prices,
  });

  factory LabBookingResponse.fromJson(Map<String, dynamic> json) {
    return LabBookingResponse(
      dates: json["dates"] == null
          ? null
          : List<LabDate>.from(
          json["dates"].map((x) => LabDate.fromJson(x))),
      slots:
      json["slots"] == null ? null : Slots.fromJson(json["slots"]),
      familyMembers: json["family_members"] == null
          ? null
          : List<FamilyMember>.from(
          json["family_members"].map((x) => FamilyMember.fromJson(x))),
      prices: json["prices"] == null
          ? null
          : List<Price>.from(
          json["prices"].map((x) => Price.fromJson(x))),
    );
  }
}
class LabDate {

  final String date;
  final String formatDate;
  final String convertDate;

  LabDate({
    required this.date,
    required this.formatDate,
    required this.convertDate,
  });

  factory LabDate.fromJson(Map<String, dynamic> json) {
    return LabDate(
      date: json["date"],
      formatDate: json["format_date"],
      convertDate: json["convert_date"],
    );
  }
}
class Slots {

  final List<Slot> morning;
  final List<Slot> afternoon;
  final List<Slot> evening;

  Slots({
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory Slots.fromJson(Map<String, dynamic> json) {
    return Slots(
      morning: List<Slot>.from(
          json["morning"].map((x) => Slot.fromJson(x))),
      afternoon: List<Slot>.from(
          json["afternoon"].map((x) => Slot.fromJson(x))),
      evening: List<Slot>.from(
          json["evening"].map((x) => Slot.fromJson(x))),
    );
  }
}
class Slot {

  final int id;
  final String time;
  final String session;
  final String bookingStatus;
  final String date;

  Slot({
    required this.id,
    required this.time,
    required this.session,
    required this.bookingStatus,
    required this.date,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json["id"],
      time: json["time"],
      session: json["session"],
      bookingStatus: json["booking_status"],
      date: json["date"],
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
      id: json["id"],
      name: json["name"],
      type: json["type"],
    );
  }
}
class Price {

  final int patientCount;
  final int price;
  final int discountPrice;

  Price({
    required this.patientCount,
    required this.price,
    required this.discountPrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      patientCount: json["patient_count"],
      price: json["price"],
      discountPrice: json["discont_price"],
    );
  }
}