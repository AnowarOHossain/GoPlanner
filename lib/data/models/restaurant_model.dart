import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location_model.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final LocationModel location;
  final double rating;
  final int reviewCount;
  final String priceRange; // $, $$, $$$, $$$$
  final String cuisine;
  final List<String> dietaryOptions; // vegetarian, vegan, gluten-free, etc.
  final List<String> mealTypes; // breakfast, lunch, dinner, snacks
  final String openingHours;
  final String? contactPhone;
  final String? website;
  final bool isOpen;
  final double averageMealPrice;
  final String currency;
  final Map<String, dynamic>? additionalInfo;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.cuisine,
    required this.dietaryOptions,
    required this.mealTypes,
    required this.openingHours,
    required this.averageMealPrice,
    required this.currency,
    this.contactPhone,
    this.website,
    this.isOpen = true,
    this.additionalInfo,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        location,
        rating,
        reviewCount,
        priceRange,
        cuisine,
        dietaryOptions,
        mealTypes,
        openingHours,
        contactPhone,
        website,
        isOpen,
        averageMealPrice,
        currency,
        additionalInfo,
      ];

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    LocationModel? location,
    double? rating,
    int? reviewCount,
    String? priceRange,
    String? cuisine,
    List<String>? dietaryOptions,
    List<String>? mealTypes,
    String? openingHours,
    String? contactPhone,
    String? website,
    bool? isOpen,
    double? averageMealPrice,
    String? currency,
    Map<String, dynamic>? additionalInfo,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceRange: priceRange ?? this.priceRange,
      cuisine: cuisine ?? this.cuisine,
      dietaryOptions: dietaryOptions ?? this.dietaryOptions,
      mealTypes: mealTypes ?? this.mealTypes,
      openingHours: openingHours ?? this.openingHours,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      isOpen: isOpen ?? this.isOpen,
      averageMealPrice: averageMealPrice ?? this.averageMealPrice,
      currency: currency ?? this.currency,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get hasHighRating => rating >= 4.0;
  
  bool get isExpensive => priceRange == '\$\$\$\$';
  
  bool get isBudgetFriendly => priceRange == '\$' || priceRange == '\$\$';
  
  bool get hasVegetarianOptions => dietaryOptions.contains('vegetarian');
  
  bool get hasVeganOptions => dietaryOptions.contains('vegan');
  
  String get formattedPrice => '$currency ${averageMealPrice.toStringAsFixed(2)}';
  
  bool get servesBreakfast => mealTypes.contains('breakfast');
  
  bool get servesLunch => mealTypes.contains('lunch');
  
  bool get servesDinner => mealTypes.contains('dinner');
}