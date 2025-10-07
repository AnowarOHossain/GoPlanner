// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferencesModel _$UserPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    UserPreferencesModel(
      userId: json['userId'] as String,
      preferredCurrency: json['preferredCurrency'] as String? ?? 'USD',
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      budgetRanges: (json['budgetRanges'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      locationEnabled: json['locationEnabled'] as bool? ?? true,
      travelStyle: TravelStyleModel.fromJson(
          json['travelStyle'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserPreferencesModelToJson(
        UserPreferencesModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'preferredCurrency': instance.preferredCurrency,
      'favoriteCategories': instance.favoriteCategories,
      'budgetRanges': instance.budgetRanges,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'preferredLanguage': instance.preferredLanguage,
      'notificationsEnabled': instance.notificationsEnabled,
      'locationEnabled': instance.locationEnabled,
      'travelStyle': instance.travelStyle,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

TravelStyleModel _$TravelStyleModelFromJson(Map<String, dynamic> json) =>
    TravelStyleModel(
      style: json['style'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      pace: json['pace'] as String,
      groupType: json['groupType'] as String,
      groupSize: (json['groupSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TravelStyleModelToJson(TravelStyleModel instance) =>
    <String, dynamic>{
      'style': instance.style,
      'interests': instance.interests,
      'pace': instance.pace,
      'groupType': instance.groupType,
      'groupSize': instance.groupSize,
    };

FavoriteItemModel _$FavoriteItemModelFromJson(Map<String, dynamic> json) =>
    FavoriteItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemType: $enumDecode(_$ItemTypeEnumMap, json['itemType']),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$FavoriteItemModelToJson(FavoriteItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'itemType': _$ItemTypeEnumMap[instance.itemType]!,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'addedAt': instance.addedAt.toIso8601String(),
    };

const _$ItemTypeEnumMap = {
  ItemType.hotel: 'hotel',
  ItemType.restaurant: 'restaurant',
  ItemType.attraction: 'attraction',
};
