// Import math library for distance calculations
import 'dart:math';
// Import Equatable to compare objects easily
import 'package:equatable/equatable.dart';

// Location data model - represents a geographic location with coordinates
class LocationModel extends Equatable {
  // Geographic coordinates
  final double latitude; // Latitude (north/south position)
  final double longitude; // Longitude (east/west position)
  
  // Address information
  final String address; // Full street address
  final String city; // City name
  final String country; // Country name
  final String? postalCode; // Postal/ZIP code (optional)

  // Constructor to create location object
  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    this.postalCode,
  });

  // Create location object from JSON data
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      postalCode: json['postalCode'] as String?,
    );
  }

  // Convert location object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
    };
  }

  // Properties to compare for equality
  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        city,
        country,
        postalCode,
      ];

  // Create a copy of location with some fields changed
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    String? postalCode,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  // Calculate distance to another location in kilometers
  // Uses Haversine formula for accuracy
  double distanceTo(LocationModel other) {
    const double earthRadius = 6371; // Earth radius in km
    
    // Convert degrees to radians
    final double lat1Rad = latitude * (pi / 180);
    final double lat2Rad = other.latitude * (pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (pi / 180);
    final double deltaLonRad = (other.longitude - longitude) * (pi / 180);

    // Haversine formula
    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLonRad / 2) *
            sin(deltaLonRad / 2);
    final double c = 2 * asin(sqrt(a));

    // Return distance in kilometers
    return earthRadius * c;
  }
}