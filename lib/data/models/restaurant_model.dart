import 'package:equatable/equatable.dart';
import 'location_model.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final LocationModel location;
  final String division;
  final String district;
  final double rating;
  final int reviewCount;
  final String priceRange; // Budget, Mid-range, Fine Dining
  final String cuisineType; // Bengali, Mughlai, Chinese, Continental, etc.
  final List<String> specialties;
  final List<String> popularDishes;
  final List<String> menuCategories;
  final String openingHours;
  final String closingHours;
  final String? contactPhone;
  final String? website;
  final bool isOpen;
  final bool hasDelivery;
  final bool hasReservation;
  final bool isHalal;
  final bool hasParking;
  final bool acceptsCards;
  final double averageCostForTwo;
  final String currency;
  final List<String> amenities;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
    required this.division,
    required this.district,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.cuisineType,
    required this.specialties,
    required this.popularDishes,
    required this.menuCategories,
    required this.openingHours,
    required this.closingHours,
    this.contactPhone,
    this.website,
    required this.isOpen,
    required this.hasDelivery,
    required this.hasReservation,
    required this.isHalal,
    required this.hasParking,
    required this.acceptsCards,
    required this.averageCostForTwo,
    required this.currency,
    required this.amenities,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List),
      location: LocationModel.fromJson({
        ...json['location'] as Map<String, dynamic>,
        'country': (json['location'] as Map<String, dynamic>)['country'] ?? 'Bangladesh',
      }),
      division: json['division'] as String,
      district: json['district'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      priceRange: json['priceRange'] as String,
      cuisineType: json['cuisineType'] as String,
      specialties: List<String>.from(json['specialties'] as List),
      popularDishes: List<String>.from(json['popularDishes'] as List),
      menuCategories: List<String>.from(json['menuCategories'] as List),
      openingHours: json['openingHours'] as String,
      closingHours: json['closingHours'] as String,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      isOpen: json['isOpen'] as bool,
      hasDelivery: json['hasDelivery'] as bool,
      hasReservation: json['hasReservation'] as bool,
      isHalal: json['isHalal'] as bool,
      hasParking: json['hasParking'] as bool,
      acceptsCards: json['acceptsCards'] as bool,
      averageCostForTwo: (json['averageCostForTwo'] as num).toDouble(),
      currency: json['currency'] as String,
      amenities: List<String>.from(json['amenities'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'location': location.toJson(),
      'division': division,
      'district': district,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'cuisineType': cuisineType,
      'specialties': specialties,
      'popularDishes': popularDishes,
      'menuCategories': menuCategories,
      'openingHours': openingHours,
      'closingHours': closingHours,
      'contactPhone': contactPhone,
      'website': website,
      'isOpen': isOpen,
      'hasDelivery': hasDelivery,
      'hasReservation': hasReservation,
      'isHalal': isHalal,
      'hasParking': hasParking,
      'acceptsCards': acceptsCards,
      'averageCostForTwo': averageCostForTwo,
      'currency': currency,
      'amenities': amenities,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        location,
        division,
        district,
        rating,
        reviewCount,
        priceRange,
        cuisineType,
        specialties,
        popularDishes,
        menuCategories,
        openingHours,
        closingHours,
        contactPhone,
        website,
        isOpen,
        hasDelivery,
        hasReservation,
        isHalal,
        hasParking,
        acceptsCards,
        averageCostForTwo,
        currency,
        amenities,
      ];

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    LocationModel? location,
    String? division,
    String? district,
    double? rating,
    int? reviewCount,
    String? priceRange,
    String? cuisineType,
    List<String>? specialties,
    List<String>? popularDishes,
    List<String>? menuCategories,
    String? openingHours,
    String? closingHours,
    String? contactPhone,
    String? website,
    bool? isOpen,
    bool? hasDelivery,
    bool? hasReservation,
    bool? isHalal,
    bool? hasParking,
    bool? acceptsCards,
    double? averageCostForTwo,
    String? currency,
    List<String>? amenities,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      division: division ?? this.division,
      district: district ?? this.district,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceRange: priceRange ?? this.priceRange,
      cuisineType: cuisineType ?? this.cuisineType,
      specialties: specialties ?? this.specialties,
      popularDishes: popularDishes ?? this.popularDishes,
      menuCategories: menuCategories ?? this.menuCategories,
      openingHours: openingHours ?? this.openingHours,
      closingHours: closingHours ?? this.closingHours,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      isOpen: isOpen ?? this.isOpen,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      hasReservation: hasReservation ?? this.hasReservation,
      isHalal: isHalal ?? this.isHalal,
      hasParking: hasParking ?? this.hasParking,
      acceptsCards: acceptsCards ?? this.acceptsCards,
      averageCostForTwo: averageCostForTwo ?? this.averageCostForTwo,
      currency: currency ?? this.currency,
      amenities: amenities ?? this.amenities,
    );
  }

  // Helper getters
  bool get hasHighRating => rating >= 4.0;
  
  bool get isFineDining => priceRange == 'Fine Dining';
  
  bool get isBudgetFriendly => priceRange == 'Budget';
  
  bool get isMidRange => priceRange == 'Mid-range';
  
  String get formattedPrice => '$currency ${averageCostForTwo.toStringAsFixed(0)} for two';
  
  bool get isBengaliCuisine => cuisineType.toLowerCase().contains('bengali');
  
  bool get hasOutdoorSeating => amenities.contains('Outdoor Seating');
  
  bool get hasWifi => amenities.contains('Free WiFi');
}