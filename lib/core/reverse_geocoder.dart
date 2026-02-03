import 'package:geocoding/geocoding.dart';

class ReverseGeocoder {
  Future<PlaceName> reverse(double lat, double lon) async {
    final list = await placemarkFromCoordinates(lat, lon);
    final p = list.isNotEmpty ? list.first : null;

    final city = (p?.locality?.trim().isNotEmpty ?? false)
        ? p!.locality!.trim()
        : (p?.administrativeArea?.trim().isNotEmpty ?? false)
            ? p!.administrativeArea!.trim()
            : 'Unknown';

    final country = (p?.country?.trim().isNotEmpty ?? false) ? p!.country!.trim() : null;

    return PlaceName(city: city, country: country);
  }
}

class PlaceName {
  final String city;
  final String? country;
  const PlaceName({required this.city, required this.country});
}
