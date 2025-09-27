import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
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

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

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
    final double lat1Rad = latitude * (3.14159 / 180);
    final double lat2Rad = other.latitude * (3.14159 / 180);
    final double deltaLatRad = (other.latitude - latitude) * (3.14159 / 180);
    final double deltaLonRad = (other.longitude - longitude) * (3.14159 / 180);

    final double a = (deltaLatRad / 2).sin() * (deltaLatRad / 2).sin() +
        lat1Rad.cos() *
            lat2Rad.cos() *
            (deltaLonRad / 2).sin() *
            (deltaLonRad / 2).sin();
    final double c = 2 * a.sqrt().asin();

    return earthRadius * c;
  }
}