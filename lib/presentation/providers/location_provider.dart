// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import Geolocator for GPS location services
import 'package:geolocator/geolocator.dart' as geo;

// Provider for location service instance
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Provider to get user's current GPS position
final currentPositionProvider = FutureProvider<geo.Position?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getCurrentPosition();
});

// Provider to check location permission status
final locationPermissionProvider = FutureProvider<geo.LocationPermission>((ref) async {
  return await geo.Geolocator.checkPermission();
});

// Provider to check if location service is enabled on device
final locationServiceEnabledProvider = FutureProvider<bool>((ref) async {
  return await geo.Geolocator.isLocationServiceEnabled();
});

// Service class to handle all location-related operations
class LocationService {
  // Get user's current GPS location
  Future<geo.Position?> getCurrentPosition() async {
    try {
      // Check if GPS is turned on
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check if app has permission to use location
      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        // Ask for permission
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get GPS coordinates
      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high, // High accuracy GPS
        timeLimit: const Duration(seconds: 10), // Timeout after 10 seconds
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Request location permission from user
  Future<bool> requestLocationPermission() async {
    try {
      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      
      return permission == geo.LocationPermission.whileInUse || 
             permission == geo.LocationPermission.always;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await geo.Geolocator.isLocationServiceEnabled();
  }

  Future<double> calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return geo.Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Stream<geo.Position> getPositionStream() {
    const geo.LocationSettings locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return geo.Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}

// Distance calculation provider
final distanceProvider = FutureProvider.family<double?, DistanceParams>((ref, params) async {
  final locationService = ref.read(locationServiceProvider);
  final currentPosition = await ref.read(currentPositionProvider.future);
  
  if (currentPosition == null) return null;
  
  return await locationService.calculateDistance(
    currentPosition.latitude,
    currentPosition.longitude,
    params.latitude,
    params.longitude,
  );
});

class DistanceParams {
  final double latitude;
  final double longitude;

  DistanceParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DistanceParams &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

// Nearby places provider
final nearbyPlacesProvider = FutureProvider.family<List<dynamic>, NearbyPlacesParams>((ref, params) async {
  // This would integrate with Google Places API
  // For now, returning mock data
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    {
      'name': 'Sample Restaurant',
      'type': 'restaurant',
      'distance': 0.5,
      'rating': 4.5,
    },
    {
      'name': 'Sample Hotel',
      'type': 'hotel',
      'distance': 1.2,
      'rating': 4.2,
    },
  ];
});

class NearbyPlacesParams {
  final double latitude;
  final double longitude;
  final double radius;
  final String type;

  NearbyPlacesParams({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearbyPlacesParams &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radius == radius &&
        other.type == type;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ radius.hashCode ^ type.hashCode;
}