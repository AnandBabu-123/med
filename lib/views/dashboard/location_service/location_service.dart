import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../models/location_model.dart';

class LocationService {

  /// ✅ GET LAT + LON + ADDRESS
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

// class LocationService {
//
//   static Future<String?> getExactAddress() async {
//     try {
//       LocationPermission permission =
//       await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         return null;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
//
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       Placemark p = placemarks.first;
//
//       List<String> parts = [
//         if (p.name != null && p.name!.isNotEmpty) p.name!,
//         if (p.thoroughfare != null) p.thoroughfare!,
//         if (p.subLocality != null) p.subLocality!,
//         if (p.locality != null) p.locality!,
//         if (p.administrativeArea != null) p.administrativeArea!,
//         if (p.postalCode != null) p.postalCode!,
//       ];
//
//       return parts.join(", ");
//     } catch (_) {
//       return null;
//     }
//   }
// }