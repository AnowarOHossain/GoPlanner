import 'dart:math';
import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;
  final String? postalCode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    this.postalCode,
  });

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

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        city,
        country,
        postalCode,
      ];

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

  double distanceTo(LocationModel other) {
    const double earthRadius = 6371; // km
    final double lat1Rad = latitude * (pi / 180);
    final double lat2Rad = other.latitude * (pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (pi / 180);
    final double deltaLonRad = (other.longitude - longitude) * (pi / 180);

    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLonRad / 2) *
            sin(deltaLonRad / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}