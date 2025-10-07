// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryModel _$ItineraryModelFromJson(Map<String, dynamic> json) =>
    ItineraryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      destination:
          LocationModel.fromJson(json['destination'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalBudget: (json['totalBudget'] as num).toDouble(),
      currency: json['currency'] as String,
      dayPlans: (json['dayPlans'] as List<dynamic>)
          .map((e) => DayPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isAiGenerated: json['isAiGenerated'] as bool? ?? false,
      userId: json['userId'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ItineraryModelToJson(ItineraryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalBudget': instance.totalBudget,
      'currency': instance.currency,
      'dayPlans': instance.dayPlans,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isAiGenerated': instance.isAiGenerated,
      'userId': instance.userId,
      'preferences': instance.preferences,
    };

DayPlanModel _$DayPlanModelFromJson(Map<String, dynamic> json) => DayPlanModel(
      dayNumber: (json['dayNumber'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ItineraryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DayPlanModelToJson(DayPlanModel instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'date': instance.date.toIso8601String(),
      'activities': instance.activities,
      'notes': instance.notes,
    };

ItineraryItemModel _$ItineraryItemModelFromJson(Map<String, dynamic> json) =>
    ItineraryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      startTime: json['startTime'] as String,
      cost: (json['cost'] as num).toDouble(),
      endTime: json['endTime'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      isBooked: json['isBooked'] as bool? ?? false,
    );

Map<String, dynamic> _$ItineraryItemModelToJson(ItineraryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'cost': instance.cost,
      'location': instance.location,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'isBooked': instance.isBooked,
    };

const _$ItemTypeEnumMap = {
  ItemType.hotel: 'hotel',
  ItemType.restaurant: 'restaurant',
  ItemType.attraction: 'attraction',
};
