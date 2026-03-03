import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../models/location_model.dart';

class LocationService {

  ///  GET LAT + LON + ADDRESS
  static Future<LocationModel?> getExactLocation() async {
    try {

      /// check permission
      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      /// get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      /// convert to address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark p = placemarks.first;

      final address = [
        p.name,
        p.locality,
        p.administrativeArea,
        p.postalCode
      ].where((e) => e != null && e!.isNotEmpty).join(", ");

      return LocationModel(
        address: address,
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
      );

    } catch (e) {
      return null;
    }
  }
}
