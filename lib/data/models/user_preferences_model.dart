import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'user_preferences_model.g.dart';

@JsonSerializable()
class UserPreferencesModel extends Equatable {
  final String userId;
  final String? preferredCurrency;
  final List<String> favoriteCategories;
  final Map<String, double> budgetRanges; // category -> max budget
  final List<String> dietaryRestrictions;
  final String? preferredLanguage;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final TravelStyleModel travelStyle;
  final DateTime lastUpdated;

  const UserPreferencesModel({
    required this.userId,
    this.preferredCurrency = 'USD',
    this.favoriteCategories = const [],
    this.budgetRanges = const {},
    this.dietaryRestrictions = const [],
    this.preferredLanguage = 'en',
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    required this.travelStyle,
    required this.lastUpdated,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);

  @override
  List<Object?> get props => [
        userId,
        preferredCurrency,
        favoriteCategories,
        budgetRanges,
        dietaryRestrictions,
        preferredLanguage,
        notificationsEnabled,
        locationEnabled,
        travelStyle,
        lastUpdated,
      ];

  UserPreferencesModel copyWith({
    String? userId,
    String? preferredCurrency,
    List<String>? favoriteCategories,
    Map<String, double>? budgetRanges,
    List<String>? dietaryRestrictions,
    String? preferredLanguage,
    bool? notificationsEnabled,
    bool? locationEnabled,
    TravelStyleModel? travelStyle,
    DateTime? lastUpdated,
  }) {
    return UserPreferencesModel(
      userId: userId ?? this.userId,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      budgetRanges: budgetRanges ?? this.budgetRanges,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      travelStyle: travelStyle ?? this.travelStyle,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@JsonSerializable()
class TravelStyleModel extends Equatable {
  final String style; // luxury, budget, backpacker, family, business, adventure
  final List<String> interests; // culture, food, nightlife, nature, history
  final String pace; // slow, moderate, fast
  final String groupType; // solo, couple, family, friends, business
  final int? groupSize;

  const TravelStyleModel({
    required this.style,
    required this.interests,
    required this.pace,
    required this.groupType,
    this.groupSize,
  });

  factory TravelStyleModel.fromJson(Map<String, dynamic> json) =>
      _$TravelStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TravelStyleModelToJson(this);

  @override
  List<Object?> get props => [style, interests, pace, groupType, groupSize];

  TravelStyleModel copyWith({
    String? style,
    List<String>? interests,
    String? pace,
    String? groupType,
    int? groupSize,
  }) {
    return TravelStyleModel(
      style: style ?? this.style,
      interests: interests ?? this.interests,
      pace: pace ?? this.pace,
      groupType: groupType ?? this.groupType,
      groupSize: groupSize ?? this.groupSize,
    );
  }
}

@JsonSerializable()
class FavoriteItemModel extends Equatable {
  final String id;
  final String itemId;
  final ItemType itemType;
  final String name;
  final String? imageUrl;
  final DateTime addedAt;

  const FavoriteItemModel({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.name,
    this.imageUrl,
    required this.addedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemModelToJson(this);

  @override
  List<Object?> get props => [id, itemId, itemType, name, imageUrl, addedAt];

  FavoriteItemModel copyWith({
    String? id,
    String? itemId,
    ItemType? itemType,
    String? name,
    String? imageUrl,
    DateTime? addedAt,
  }) {
    return FavoriteItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}