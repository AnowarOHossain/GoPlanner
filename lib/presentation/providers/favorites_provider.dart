// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import cart item model for ItemType enum
import '../../data/models/cart_item_model.dart';

// Main favorites provider - manages favorite items by type
// Stores favorites as a map: ItemType -> List of IDs
final favoritesNotifierProvider = StateNotifierProvider<FavoritesNotifier, Map<ItemType, List<String>>>((ref) {
  return FavoritesNotifier();
});

// Provider for favorite hotel IDs (as a Set for quick lookup)
final favoriteHotelsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.hotel] ?? []);
});

// Provider for favorite restaurant IDs
final favoriteRestaurantsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.restaurant] ?? []);
});

// Provider for favorite attraction IDs
final favoriteAttractionsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.attraction] ?? []);
});

// Favorites state manager - handles all favorite operations
class FavoritesNotifier extends StateNotifier<Map<ItemType, List<String>>> {
  // Initialize with empty favorites map
  FavoritesNotifier() : super({});

  // Check if an item is in favorites
  bool isFavorite(String id, ItemType itemType) {
    final favorites = state[itemType] ?? [];
    return favorites.contains(id);
  }

  // Add or remove item from favorites (toggle)
  void toggleFavorite(String id, ItemType itemType) {
    // Create a copy of current state
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    if (favorites.contains(id)) {
      // Remove from favorites
      favorites.remove(id);
    } else {
      // Add to favorites
      favorites.add(id);
    }
    
    // Update state
    currentFavorites[itemType] = favorites;
    state = currentFavorites;
  }

  // Add item to favorites (doesn't remove if already exists)
  void addToFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    // Only add if not already in favorites
    if (!favorites.contains(id)) {
      favorites.add(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
    }
  }

  // Remove item from favorites
  void removeFromFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    // Only remove if in favorites
    if (favorites.contains(id)) {
      favorites.remove(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
    }
  }

  // Get all favorite IDs for a specific type
  List<String> getFavorites(ItemType itemType) {
    return state[itemType] ?? [];
  }
}