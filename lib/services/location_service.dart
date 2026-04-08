import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Holds the data returned after a successful location fetch.
class LocationData {
  final double latitude;
  final double longitude;

  /// Optional: city or region name obtained via reverse geocoding.
  final String? cityName;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.cityName,
  });
}

/// Service for GPS location operations.
/// Uses [geolocator] for position and [geocoding] for reverse geocoding.
class LocationService {
  static final LocationService instance = LocationService._init();
  LocationService._init();

  /// Requests permission (if needed) and returns the current [LocationData].
  ///
  /// Throws a descriptive [Exception] for:
  ///   - Location services disabled
  ///   - Permission denied (temporary or permanent)
  ///   - Any other unexpected error
  Future<LocationData> getCurrentLocation() async {
    // Step 1: Ensure location services (GPS) are enabled on the device.
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable GPS in your device Settings.',
      );
    }

    // Step 2: Check current permission status and request if needed.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission denied. Please allow location access when prompted.',
        );
      }
    }

    // Step 3: Handle the "denied forever" case – user must go to app Settings.
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. '
        'Please enable it in your device App Settings.',
      );
    }

    // Step 4: Fetch the current device position.
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    // Step 5: Optional reverse geocoding to obtain a human-readable city name.
    String? city;
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // Prefer locality (city), fall back to sub-admin or admin area.
        city = place.locality?.isNotEmpty == true
            ? place.locality
            : (place.subAdministrativeArea?.isNotEmpty == true
                ? place.subAdministrativeArea
                : place.administrativeArea);
      }
    } catch (_) {
      // Geocoding is optional – silently ignore network / decode errors.
    }

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      cityName: city,
    );
  }
}
