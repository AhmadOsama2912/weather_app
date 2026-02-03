import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Throws [LocationException] with a user-readable message.
  Future<Position> determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission permanently denied. Please enable it from Settings.',
        canOpenSettings: true,
      );
    }

    // When granted (whileInUse/always) → fetch current position
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 12),
    );
  }
}

class LocationException implements Exception {
  final String message;
  final bool canOpenSettings;
  const LocationException(this.message, {this.canOpenSettings = false});
}
