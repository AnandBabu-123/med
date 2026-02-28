import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationModel {
  final String address;
  final String lat;
  final String lon;

  LocationModel({
    required this.address,
    required this.lat,
    required this.lon,
  });
}

class LocationService {
  static Future<LocationModel?> getExactLocation() async {
    LocationPermission permission =
    await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placeMarks =
    await placemarkFromCoordinates(
        position.latitude, position.longitude);

    final place = placeMarks.first;

    String address =
        "${place.locality}, ${place.administrativeArea}";

    return LocationModel(
      address: address,
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
    );
  }
}