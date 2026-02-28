abstract class PostAddressEvent {}

class SubmitAddressEvent extends PostAddressEvent {
  final String address;
  final String hno;
  final String buildingNo;
  final String landmark;
  final String lat;
  final String lon;
  final String state;
  final String city;
  final String pincode;
  final String addressType;

  SubmitAddressEvent({
    required this.address,
    required this.hno,
    required this.buildingNo,
    required this.landmark,
    required this.lat,
    required this.lon,
    required this.state,
    required this.city,
    required this.pincode,
    required this.addressType,
  });
}