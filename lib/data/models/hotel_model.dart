import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location_model.dart';

part 'hotel_model.g.dart';

@JsonSerializable()
class HotelModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final LocationModel location;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String currency;
  final List<String> amenities;
  final String category; // luxury, budget, mid-range
  final bool isAvailable;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? contactPhone;
  final String? website;
  final Map<String, dynamic>? additionalInfo;

  const HotelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.currency,
    required this.amenities,
    required this.category,
    this.isAvailable = true,
    this.checkInDate,
    this.checkOutDate,
    this.contactPhone,
    this.website,
    this.additionalInfo,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) =>
      _$HotelModelFromJson(json);

  Map<String, dynamic> toJson() => _$HotelModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        location,
        rating,
        reviewCount,
        pricePerNight,
        currency,
        amenities,
        category,
        isAvailable,
        checkInDate,
        checkOutDate,
        contactPhone,
        website,
        additionalInfo,
      ];

  HotelModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    LocationModel? location,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    String? currency,
    List<String>? amenities,
    String? category,
    bool? isAvailable,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? contactPhone,
    String? website,
    Map<String, dynamic>? additionalInfo,
  }) {
    return HotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      currency: currency ?? this.currency,
      amenities: amenities ?? this.amenities,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  double calculateTotalPrice(int nights) {
    return pricePerNight * nights;
  }

  bool get hasHighRating => rating >= 4.0;
  
  bool get isLuxury => category.toLowerCase() == 'luxury';
  
  bool get isBudget => category.toLowerCase() == 'budget';
  
  String get formattedPrice => '${currency} ${pricePerNight.toStringAsFixed(2)}';
}