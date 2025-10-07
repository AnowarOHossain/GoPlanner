// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelModel _$HotelModelFromJson(Map<String, dynamic> json) => HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      currency: json['currency'] as String,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      checkInDate: json['checkInDate'] == null
          ? null
          : DateTime.parse(json['checkInDate'] as String),
      checkOutDate: json['checkOutDate'] == null
          ? null
          : DateTime.parse(json['checkOutDate'] as String),
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HotelModelToJson(HotelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'location': instance.location,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'pricePerNight': instance.pricePerNight,
      'currency': instance.currency,
      'amenities': instance.amenities,
      'category': instance.category,
      'isAvailable': instance.isAvailable,
      'checkInDate': instance.checkInDate?.toIso8601String(),
      'checkOutDate': instance.checkOutDate?.toIso8601String(),
      'contactPhone': instance.contactPhone,
      'website': instance.website,
      'additionalInfo': instance.additionalInfo,
    };
