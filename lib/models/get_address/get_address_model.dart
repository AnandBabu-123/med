class GetAddressModel {
  final bool status;
  final String message;
  final AddressResponse response;

  GetAddressModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory GetAddressModel.fromJson(Map<String, dynamic> json) {
    return GetAddressModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      response: AddressResponse.fromJson(json["response"] ?? {}),
    );
  }
}

class AddressResponse {
  final List<AddressItem> address;

  AddressResponse({
    required this.address,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      address: (json["address"] as List? ?? [])
          .map((e) => AddressItem.fromJson(e))
          .toList(),
    );
  }
}

class AddressItem {
  final int id;
  final int userId;
  final String address;
  final String hno;
  final String buildingNo;
  final String landmark;
  final String lat;
  final String lon;
  final String addressType;
  final int pincode;
  final String state;
  final String city;
  final int defaultAddress;
  final int status;
  final int deleteStatus;
  final String createdOn;
  final String? modifiedOn;

  AddressItem({
    required this.id,
    required this.userId,
    required this.address,
    required this.hno,
    required this.buildingNo,
    required this.landmark,
    required this.lat,
    required this.lon,
    required this.addressType,
    required this.pincode,
    required this.state,
    required this.city,
    required this.defaultAddress,
    required this.status,
    required this.deleteStatus,
    required this.createdOn,
    this.modifiedOn,
  });

  factory AddressItem.fromJson(Map<String, dynamic> json) {
    return AddressItem(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      address: json["address"] ?? "",
      hno: json["hno"] ?? "",
      buildingNo: json["building_no"] ?? "",
      landmark: json["landmark"] ?? "",
      lat: json["lat"]?.toString() ?? "",
      lon: json["lon"]?.toString() ?? "",
      addressType: json["address_type"] ?? "",
      pincode: json["pincode"] ?? 0,
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      defaultAddress: json["default_address"] ?? 0,
      status: json["status"] ?? 0,
      deleteStatus: json["delete_status"] ?? 0,
      createdOn: json["created_on"] ?? "",
      modifiedOn: json["modified_on"],
    );
  }
}