// Import Equatable to compare objects easily
import 'package:equatable/equatable.dart';
// Import cart item model
import 'cart_item_model.dart';

// User preferences model - stores user's settings and preferences

// Main user preferences class
class UserPreferencesModel extends Equatable {
  final String userId; // User's unique ID
  final String? preferredCurrency; // Preferred currency (e.g., BDT, USD)
  final List<String> favoriteCategories; // Favorite types (hotels, food, etc.)
  final Map<String, double> budgetRanges; // Budget limits by category
  final List<String> dietaryRestrictions; // Food restrictions (vegan, halal, etc.)
  final String? preferredLanguage; // App language preference
  final bool notificationsEnabled; // Allow notifications
  final bool locationEnabled; // Allow location access
  final TravelStyleModel travelStyle; // How user likes to travel
  final DateTime lastUpdated; // When preferences were last changed

  const UserPreferencesModel({
    required this.userId,
    this.preferredCurrency = 'BDT', // Default to Bangladesh Taka
    this.favoriteCategories = const [],
    this.budgetRanges = const {},
    this.dietaryRestrictions = const [],
    this.preferredLanguage = 'en',
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    required this.travelStyle,
    required this.lastUpdated,
  });

  // Create preferences from JSON data
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      userId: json['userId'] as String,
      preferredCurrency: json['preferredCurrency'] as String?,
      favoriteCategories: List<String>.from(json['favoriteCategories'] as List? ?? []),
      budgetRanges: Map<String, double>.from(
        (json['budgetRanges'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] as List? ?? []),
      preferredLanguage: json['preferredLanguage'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      locationEnabled: json['locationEnabled'] as bool? ?? true,
      travelStyle: TravelStyleModel.fromJson(json['travelStyle'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  // Convert preferences to JSON data
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'preferredCurrency': preferredCurrency,
      'favoriteCategories': favoriteCategories,
      'budgetRanges': budgetRanges,
      'dietaryRestrictions': dietaryRestrictions,
      'preferredLanguage': preferredLanguage,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'travelStyle': travelStyle.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

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

  // Helper getters
  bool get hasHalalPreference => dietaryRestrictions.contains('halal');
  bool get hasVegetarianPreference => dietaryRestrictions.contains('vegetarian');
  bool get hasVeganPreference => dietaryRestrictions.contains('vegan');
  
  double getBudgetForCategory(String category) => budgetRanges[category] ?? 0.0;
  
  bool isCategoryFavorite(String category) => favoriteCategories.contains(category);
}

class TravelStyleModel extends Equatable {
  final String adventureLevel; // low, medium, high
  final String budgetLevel; // budget, mid-range, luxury
  final String pace; // slow, moderate, fast
  final List<String> interests;
  final bool preferGroupTravel;

  const TravelStyleModel({
    required this.adventureLevel,
    required this.budgetLevel,
    required this.pace,
    required this.interests,
    this.preferGroupTravel = false,
  });

  factory TravelStyleModel.fromJson(Map<String, dynamic> json) {
    return TravelStyleModel(
      adventureLevel: json['adventureLevel'] as String,
      budgetLevel: json['budgetLevel'] as String,
      pace: json['pace'] as String,
      interests: List<String>.from(json['interests'] as List),
      preferGroupTravel: json['preferGroupTravel'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adventureLevel': adventureLevel,
      'budgetLevel': budgetLevel,
      'pace': pace,
      'interests': interests,
      'preferGroupTravel': preferGroupTravel,
    };
  }

  @override
  List<Object?> get props => [
        adventureLevel,
        budgetLevel,
        pace,
        interests,
        preferGroupTravel,
      ];

  TravelStyleModel copyWith({
    String? adventureLevel,
    String? budgetLevel,
    String? pace,
    List<String>? interests,
    bool? preferGroupTravel,
  }) {
    return TravelStyleModel(
      adventureLevel: adventureLevel ?? this.adventureLevel,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      pace: pace ?? this.pace,
      interests: interests ?? this.interests,
      preferGroupTravel: preferGroupTravel ?? this.preferGroupTravel,
    );
  }

  // Helper getters
  bool get isAdventurous => adventureLevel == 'high';
  bool get isBudgetTraveler => budgetLevel == 'budget';
  bool get isLuxuryTraveler => budgetLevel == 'luxury';
  bool get isFastPaced => pace == 'fast';
  bool hasInterest(String interest) => interests.contains(interest);
}

class FavoriteItemModel extends Equatable {
  final String id;
  final String itemId;
  final ItemType type;
  final String name;
  final DateTime addedAt;
  final String? notes;

  const FavoriteItemModel({
    required this.id,
    required this.itemId,
    required this.type,
    required this.name,
    required this.addedAt,
    this.notes,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      type: ItemType.values.firstWhere((e) => e.name == json['type'] as String),
      name: json['name'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'type': type.name,
      'name': name,
      'addedAt': addedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, itemId, type, name, addedAt, notes];

  FavoriteItemModel copyWith({
    String? id,
    String? itemId,
    ItemType? type,
    String? name,
    DateTime? addedAt,
    String? notes,
  }) {
    return FavoriteItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      name: name ?? this.name,
      addedAt: addedAt ?? this.addedAt,
      notes: notes ?? this.notes,
    );
  }

  // Helper getters
  bool get isHotel => type == ItemType.hotel;
  bool get isRestaurant => type == ItemType.restaurant;
  bool get isAttraction => type == ItemType.attraction;
  
  Duration get timeSinceAdded => DateTime.now().difference(addedAt);
}