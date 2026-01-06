// This file manages favorites state using Riverpod and syncs with Firebase
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item_model.dart';
import '../../core/services/favorites_service.dart';
import 'auth_providers.dart';

// Provider for the FavoritesService instance
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

// Main favorites provider - stores favorite item IDs by type
final favoritesNotifierProvider = StateNotifierProvider<FavoritesNotifier, Map<ItemType, List<String>>>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  final user = ref.watch(currentUserProvider);
  return FavoritesNotifier(service, user?.uid);
});

// Provider for favorite hotel IDs
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

// Manages favorites state and syncs with Firebase
class FavoritesNotifier extends StateNotifier<Map<ItemType, List<String>>> {
  final FavoritesService _service;
  final String? _userId;

  FavoritesNotifier(this._service, this._userId) : super({}) {
    if (_userId != null) {
      _loadFavorites();
    }
  }

  // Load favorites from Firebase
  Future<void> _loadFavorites() async {
    try {
      final data = await _service.loadFavorites();
      state = {
        ItemType.hotel: data['hotels'] ?? [],
        ItemType.restaurant: data['restaurants'] ?? [],
        ItemType.attraction: data['attractions'] ?? [],
      };
      print('Loaded favorites from cloud: ${state}');
    } catch (e) {
      print('Error loading favorites: $e');
    }
  } 

  // Check if an item is in favorites
  bool isFavorite(String id, ItemType itemType) {
    final favorites = state[itemType] ?? [];
    return favorites.contains(id);
  }

  // Toggle favorite status (add or remove)
  void toggleFavorite(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    
    if (favorites.contains(id)) {
      favorites.remove(id);
      if (_userId != null) {
        _service.removeFavorite(id, _getTypeString(itemType));
      }
    } else {
      favorites.add(id);
      if (_userId != null) {
        _service.addFavorite(id, _getTypeString(itemType));
      }
    }
    currentFavorites[itemType] = favorites;
    state = currentFavorites;
  }

  // Convert ItemType to string for Firestore
  String _getTypeString(ItemType type) {
    switch (type) {
      case ItemType.hotel:
        return 'hotels';
      case ItemType.restaurant:
        return 'restaurants';
      case ItemType.attraction:
        return 'attractions';
    }
  }

  // Add item to favorites
  void addToFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    if (!favorites.contains(id)) {
      favorites.add(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
      if (_userId != null) {
        _service.addFavorite(id, _getTypeString(itemType));
      }
    }
  }

  // Remove item from favorites
  void removeFromFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    if (favorites.contains(id)) {
      favorites.remove(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
      if (_userId != null) {
        _service.removeFavorite(id, _getTypeString(itemType));
      }
    }
  }

  // Get all favorite IDs for a type
  List<String> getFavorites(ItemType itemType) {
    return state[itemType] ?? [];
  }
}
