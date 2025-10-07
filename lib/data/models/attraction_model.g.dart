// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attraction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttractionModel _$AttractionModelFromJson(Map<String, dynamic> json) =>
    AttractionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      currency: json['currency'] as String,
      category: json['category'] as String,
      openingHours: json['openingHours'] as String,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      entryFee: (json['entryFee'] as num?)?.toDouble(),
      isAccessible: json['isAccessible'] as bool? ?? true,
      isFree: json['isFree'] as bool? ?? false,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      bestTimeToVisit: (json['bestTimeToVisit'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AttractionModelToJson(AttractionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'location': instance.location,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'entryFee': instance.entryFee,
      'currency': instance.currency,
      'category': instance.category,
      'openingHours': instance.openingHours,
      'estimatedDuration': instance.estimatedDuration,
      'activities': instance.activities,
      'isAccessible': instance.isAccessible,
      'isFree': instance.isFree,
      'contactPhone': instance.contactPhone,
      'website': instance.website,
      'bestTimeToVisit': instance.bestTimeToVisit,
      'additionalInfo': instance.additionalInfo,
    };
