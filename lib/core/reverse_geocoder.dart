import 'package:geocoding/geocoding.dart';

class ReverseGeocoder {
  Future<(String city, String? country)> cityFromCoords({
    required double lat,
    required double lon,
  }) async {
    final placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isEmpty) {
      return ('Current location', null);
    }

    final p = placemarks.first;
    final city = p.locality?.trim().isNotEmpty == true
        ? p.locality!.trim()
        : (p.subAdministrativeArea?.trim().isNotEmpty == true
              ? p.subAdministrativeArea!.trim()
              : (p.administrativeArea?.trim().isNotEmpty == true
                    ? p.administrativeArea!.trim()
                    : 'Current location'));

    return (city, p.country);
  }
}
