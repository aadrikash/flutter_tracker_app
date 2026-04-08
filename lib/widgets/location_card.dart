import 'package:flutter/material.dart';
import '../services/location_service.dart';

/// Card widget that displays the user's current GPS location.
///
/// Consistent with the app's existing gradient-card design language.
/// State is self-contained – just drop [LocationCard] anywhere in a [Column].
class LocationCard extends StatefulWidget {
  const LocationCard({super.key});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  /// Holds the fetched location; null if not yet fetched.
  LocationData? _locationData;

  /// True while the GPS request is in-flight.
  bool _isLoading = false;

  /// Non-null when an error occurred during the last fetch.
  String? _errorMessage;

  /// Triggers a GPS location fetch through [LocationService].
  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final LocationData data =
          await LocationService.instance.getCurrentLocation();
      if (mounted) {
        setState(() {
          _locationData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Strip the "Exception:" prefix for a cleaner user-facing message.
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00897B), Color(0xFF26C6DA)], // teal → cyan
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────────────────────────────
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Current Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Content area ─────────────────────────────────────────────────
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else if (_errorMessage != null)
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            )
          else if (_locationData != null) ...[
            _buildInfoRow(Icons.my_location, 'Latitude',
                _locationData!.latitude.toStringAsFixed(5)),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.explore, 'Longitude',
                _locationData!.longitude.toStringAsFixed(5)),
            if (_locationData!.cityName != null &&
                _locationData!.cityName!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                  Icons.location_city, 'City', _locationData!.cityName!),
            ],
          ] else
            const Text(
              'Tap "Get Current Location" to see where you are.',
              style: TextStyle(color: Colors.white70),
            ),

          const SizedBox(height: 16),

          // ── Action button ─────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00897B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isLoading ? null : _fetchLocation,
              icon: const Icon(Icons.gps_fixed),
              label: const Text(
                'Get Current Location',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single labelled info row inside the card.
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white70),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
