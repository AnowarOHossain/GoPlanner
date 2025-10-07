// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      priceRange: json['priceRange'] as String,
      cuisine: json['cuisine'] as String,
      dietaryOptions: (json['dietaryOptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mealTypes:
          (json['mealTypes'] as List<dynamic>).map((e) => e as String).toList(),
      openingHours: json['openingHours'] as String,
      averageMealPrice: (json['averageMealPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      isOpen: json['isOpen'] as bool? ?? true,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'location': instance.location,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'priceRange': instance.priceRange,
      'cuisine': instance.cuisine,
      'dietaryOptions': instance.dietaryOptions,
      'mealTypes': instance.mealTypes,
      'openingHours': instance.openingHours,
      'contactPhone': instance.contactPhone,
      'website': instance.website,
      'isOpen': instance.isOpen,
      'averageMealPrice': instance.averageMealPrice,
      'currency': instance.currency,
      'additionalInfo': instance.additionalInfo,
    };
