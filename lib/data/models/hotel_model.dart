// Import Equatable to compare objects easily
import 'package:equatable/equatable.dart';
// Import location model for hotel address
import 'location_model.dart';

// Hotel data model - represents a hotel with all its information
class HotelModel extends Equatable {
  // Basic hotel information
  final String id; // Unique identifier
  final String name; // Hotel name
  final String description; // Hotel description
  final List<String> images; // List of image URLs
  final LocationModel location; // Hotel address
  
  // Rating and pricing
  final double rating; // Rating out of 5
  final int reviewCount; // Number of reviews
  final double pricePerNight; // Price per night
  final String currency; // Currency (e.g., BDT)
  
  // Hotel features
  final List<String> amenities; // WiFi, pool, gym, etc.
  final String category; // luxury, business, standard, budget, resort, heritage
  final bool isAvailable; // Is hotel available for booking
  
  // Date information
  final DateTime? checkInDate; // Optional check-in date
  final DateTime? checkOutDate; // Optional check-out date
  
  // Contact information
  final String? contactPhone; // Hotel phone number
  final String? website; // Hotel website
  
  // Location details
  final String division; // Bangladesh division (Dhaka, Chittagong, etc.)
  final String district; // District name
  
  // Hotel characteristics
  final String hotelType; // business, resort, heritage, budget, luxury
  final int totalRooms; // Number of rooms
  final List<String> nearbyAttractions; // Nearby places
  
  // Timing
  final String checkInTime; // Check-in time
  final String checkOutTime; // Check-out time
  
  // Facilities
  final bool hasParking; // Parking available
  final bool hasAirport; // Airport transfer available
  
  // Extra information
  final Map<String, dynamic>? additionalInfo; // Other details

  // Constructor to create hotel object
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
    required this.division,
    required this.district,
    required this.hotelType,
    required this.totalRooms,
    required this.nearbyAttractions,
    this.checkInTime = '2:00 PM',
    this.checkOutTime = '12:00 PM',
    this.isAvailable = true,
    this.hasParking = false,
    this.hasAirport = false,
    this.checkInDate,
    this.checkOutDate,
    this.contactPhone,
    this.website,
    this.additionalInfo,
  });

  // Create hotel object from JSON data
  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List),
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      currency: json['currency'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      category: json['category'] as String,
      division: json['division'] as String,
      district: json['district'] as String,
      hotelType: json['hotelType'] as String,
      totalRooms: json['totalRooms'] as int,
      nearbyAttractions: List<String>.from(json['nearbyAttractions'] as List),
      checkInTime: json['checkInTime'] as String? ?? '2:00 PM',
      checkOutTime: json['checkOutTime'] as String? ?? '12:00 PM',
      isAvailable: json['isAvailable'] as bool? ?? true,
      hasParking: json['hasParking'] as bool? ?? false,
      hasAirport: json['hasAirport'] as bool? ?? false,
      checkInDate: json['checkInDate'] != null ? DateTime.parse(json['checkInDate'] as String) : null,
      checkOutDate: json['checkOutDate'] != null ? DateTime.parse(json['checkOutDate'] as String) : null,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'location': location.toJson(),
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerNight': pricePerNight,
      'currency': currency,
      'amenities': amenities,
      'category': category,
      'division': division,
      'district': district,
      'hotelType': hotelType,
      'totalRooms': totalRooms,
      'nearbyAttractions': nearbyAttractions,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'isAvailable': isAvailable,
      'hasParking': hasParking,
      'hasAirport': hasAirport,
      'checkInDate': checkInDate?.toIso8601String(),
      'checkOutDate': checkOutDate?.toIso8601String(),
      'contactPhone': contactPhone,
      'website': website,
      'additionalInfo': additionalInfo,
    };
  }

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
        division,
        district,
        hotelType,
        totalRooms,
        nearbyAttractions,
        checkInTime,
        checkOutTime,
        isAvailable,
        hasParking,
        hasAirport,
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
    String? division,
    String? district,
    String? hotelType,
    int? totalRooms,
    List<String>? nearbyAttractions,
    String? checkInTime,
    String? checkOutTime,
    bool? isAvailable,
    bool? hasParking,
    bool? hasAirport,
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
      division: division ?? this.division,
      district: district ?? this.district,
      hotelType: hotelType ?? this.hotelType,
      totalRooms: totalRooms ?? this.totalRooms,
      nearbyAttractions: nearbyAttractions ?? this.nearbyAttractions,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isAvailable: isAvailable ?? this.isAvailable,
      hasParking: hasParking ?? this.hasParking,
      hasAirport: hasAirport ?? this.hasAirport,
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
  
  String get formattedPrice => '$currency ${pricePerNight.toStringAsFixed(2)}';
}