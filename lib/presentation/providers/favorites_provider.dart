import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_preferences_model.dart';
import '../data/models/cart_item_model.dart';

part 'favorites_provider.g.dart';

@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  List<FavoriteItemModel> build() {
    return [];
  }

  Future<void> loadFavorites() async {
    try {
      // TODO: Load from local storage or Firebase
      final favorites = await _loadFavoritesFromStorage();
      state = favorites;
    } catch (error) {
      // Handle error
      state = [];
    }
  }

  Future<void> addToFavorites(FavoriteItemModel item) async {
    // Check if already in favorites
    if (state.any((fav) => fav.itemId == item.itemId && fav.itemType == item.itemType)) {
      return;
    }

    state = [...state, item];
    
    // Save to local storage/Firebase
    await _saveFavoritesToStorage(state);
  }

  Future<void> removeFromFavorites(String itemId, ItemType itemType) async {
    state = state.where((fav) => 
      !(fav.itemId == itemId && fav.itemType == itemType)
    ).toList();
    
    // Save to local storage/Firebase
    await _saveFavoritesToStorage(state);
  }

  bool isFavorite(String itemId, ItemType itemType) {
    return state.any((fav) => 
      fav.itemId == itemId && fav.itemType == itemType
    );
  }

  List<FavoriteItemModel> getFavoritesByType(ItemType type) {
    return state.where((fav) => fav.itemType == type).toList();
  }

  Future<List<FavoriteItemModel>> _loadFavoritesFromStorage() async {
    // TODO: Implement actual storage loading
    // This could be from Hive, SharedPreferences, or Firebase
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<void> _saveFavoritesToStorage(List<FavoriteItemModel> favorites) async {
    // TODO: Implement actual storage saving
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

// User preferences provider
@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  @override
  UserPreferencesModel? build() {
    return null;
  }

  Future<void> loadUserPreferences() async {
    try {
      final preferences = await _loadPreferencesFromStorage();
      state = preferences;
    } catch (error) {
      // Set default preferences
      state = _getDefaultPreferences();
    }
  }

  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    state = preferences;
    await _savePreferencesToStorage(preferences);
  }

  Future<void> updateTravelStyle(TravelStyleModel travelStyle) async {
    if (state != null) {
      final updatedPreferences = state!.copyWith(
        travelStyle: travelStyle,
        lastUpdated: DateTime.now(),
      );
      await updatePreferences(updatedPreferences);
    }
  }

  Future<void> updateBudgetRange(String category, double maxBudget) async {
    if (state != null) {
      final updatedBudgetRanges = Map<String, double>.from(state!.budgetRanges);
      updatedBudgetRanges[category] = maxBudget;
      
      final updatedPreferences = state!.copyWith(
        budgetRanges: updatedBudgetRanges,
        lastUpdated: DateTime.now(),
      );
      await updatePreferences(updatedPreferences);
    }
  }

  Future<void> addDietaryRestriction(String restriction) async {
    if (state != null && !state!.dietaryRestrictions.contains(restriction)) {
      final updatedRestrictions = [...state!.dietaryRestrictions, restriction];
      final updatedPreferences = state!.copyWith(
        dietaryRestrictions: updatedRestrictions,
        lastUpdated: DateTime.now(),
      );
      await updatePreferences(updatedPreferences);
    }
  }

  Future<void> removeDietaryRestriction(String restriction) async {
    if (state != null) {
      final updatedRestrictions = state!.dietaryRestrictions
          .where((r) => r != restriction)
          .toList();
      final updatedPreferences = state!.copyWith(
        dietaryRestrictions: updatedRestrictions,
        lastUpdated: DateTime.now(),
      );
      await updatePreferences(updatedPreferences);
    }
  }

  Future<UserPreferencesModel?> _loadPreferencesFromStorage() async {
    // TODO: Implement actual storage loading
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  Future<void> _savePreferencesToStorage(UserPreferencesModel preferences) async {
    // TODO: Implement actual storage saving
    await Future.delayed(const Duration(milliseconds: 100));
  }

  UserPreferencesModel _getDefaultPreferences() {
    return UserPreferencesModel(
      userId: 'default_user', // TODO: Get actual user ID
      preferredCurrency: 'USD',
      favoriteCategories: [],
      budgetRanges: {
        'hotel': 200.0,
        'restaurant': 50.0,
        'attraction': 30.0,
      },
      dietaryRestrictions: [],
      preferredLanguage: 'en',
      notificationsEnabled: true,
      locationEnabled: true,
      travelStyle: const TravelStyleModel(
        style: 'moderate',
        interests: ['culture', 'food'],
        pace: 'moderate',
        groupType: 'solo',
        groupSize: 1,
      ),
      lastUpdated: DateTime.now(),
    );
  }
}