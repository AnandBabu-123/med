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
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      response: LabBookingResponse.fromJson(json["response"] ?? {}),
    );
  }
}

class LabBookingResponse {

  final List<LabDate> dates;
  final Slots? slots;
  final List<FamilyMembers> familyMembers;
  final List<Prices> prices;

  LabBookingResponse({
    required this.dates,
    this.slots,
    required this.familyMembers,
    required this.prices,
  });

  factory LabBookingResponse.fromJson(Map<String, dynamic> json) {

    return LabBookingResponse(

      dates: json["dates"] == null
          ? []
          : (json["dates"] as List)
          .map((e) => LabDate.fromJson(e))
          .toList(),

      slots: json["slots"] == null
          ? null
          : Slots.fromJson(json["slots"]),

      familyMembers: json["family_members"] == null
          ? []
          : (json["family_members"] as List)
          .map((e) => FamilyMembers.fromJson(e))
          .toList(),

      prices: json["prices"] == null
          ? []
          : (json["prices"] as List)
          .map((e) => Prices.fromJson(e))
          .toList(),
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
      date: json["date"] ?? "",
      formatDate: json["format_date"] ?? "",
      convertDate: json["convert_date"] ?? "",
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

      morning: json["morning"] == null
          ? []
          : (json["morning"] as List)
          .map((e) => Slot.fromJson(e))
          .toList(),

      afternoon: json["afternoon"] == null
          ? []
          : (json["afternoon"] as List)
          .map((e) => Slot.fromJson(e))
          .toList(),

      evening: json["evening"] == null
          ? []
          : (json["evening"] as List)
          .map((e) => Slot.fromJson(e))
          .toList(),
    );
  }
}

class Slot {

  final int id;
  final String time;
  final String bookingStatus;

  Slot({
    required this.id,
    required this.time,
    required this.bookingStatus,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {

    return Slot(
      id: json["id"] ?? 0,
      time: json["time"] ?? "",
      bookingStatus: json["booking_status"] ?? "",
    );
  }
}

class FamilyMembers {

  final int id;
  final String name;
  final String type;

  FamilyMembers({
    required this.id,
    required this.name,
    required this.type,
  });

  factory FamilyMembers.fromJson(Map<String, dynamic> json) {

    return FamilyMembers(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      type: json["type"] ?? "",
    );
  }
}

class Prices {

  final int patientCount;
  final int price;
  final int discountPrice;

  Prices({
    required this.patientCount,
    required this.price,
    required this.discountPrice,
  });

  factory Prices.fromJson(Map<String, dynamic> json) {

    return Prices(
      patientCount: json["patient_count"] ?? 0,
      price: json["price"] ?? 0,
      discountPrice: json["discont_price"] ?? 0,
    );
  }
}