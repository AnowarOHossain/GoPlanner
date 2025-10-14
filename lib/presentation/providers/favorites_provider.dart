import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item_model.dart';

// Simple favorites state
final favoritesNotifierProvider = StateNotifierProvider<FavoritesNotifier, Map<ItemType, List<String>>>((ref) {
  return FavoritesNotifier();
});

// Individual favorites providers for easier access
final favoriteHotelsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.hotel] ?? []);
});

final favoriteRestaurantsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.restaurant] ?? []);
});

final favoriteAttractionsProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesNotifierProvider);
  return Set<String>.from(favorites[ItemType.attraction] ?? []);
});

class FavoritesNotifier extends StateNotifier<Map<ItemType, List<String>>> {
  FavoritesNotifier() : super({});

  bool isFavorite(String id, ItemType itemType) {
    final favorites = state[itemType] ?? [];
    return favorites.contains(id);
  }

  void toggleFavorite(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    
    currentFavorites[itemType] = favorites;
    state = currentFavorites;
  }

  void addToFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    if (!favorites.contains(id)) {
      favorites.add(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
    }
  }

  void removeFromFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = currentFavorites[itemType] ?? [];
    
    if (favorites.contains(id)) {
      favorites.remove(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
    }
  }

  List<String> getFavorites(ItemType itemType) {
    return state[itemType] ?? [];
  }
}