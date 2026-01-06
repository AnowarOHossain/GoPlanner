// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import cart item model for ItemType enum
import '../../data/models/cart_item_model.dart';
// Import Firebase Firestore service for persistence
import '../../core/services/favorites_service.dart';
// Import auth providers to watch user state
import 'auth_providers.dart';

// Provider for the FavoritesService
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

// Main favorites provider - manages favorite items by type
// Stores favorites as a map: ItemType -> List of IDs
// Now persists to Firestore when user is logged in
final favoritesNotifierProvider = StateNotifierProvider<FavoritesNotifier, Map<ItemType, List<String>>>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  final user = ref.watch(currentUserProvider);
  return FavoritesNotifier(service, user?.uid);
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
// Now syncs with Firebase Firestore for persistence
class FavoritesNotifier extends StateNotifier<Map<ItemType, List<String>>> {
  final FavoritesService _service;
  final String? _userId;

  // Initialize with empty favorites map, then load from Firestore if logged in
  FavoritesNotifier(this._service, this._userId) : super({}) {
    if (_userId != null) {
      _loadFavorites();
    }
  }

  // Load favorites from Firestore
  Future<void> _loadFavorites() async {
    try {
      final data = await _service.loadFavorites();
      state = {
        ItemType.hotel: data['hotels'] ?? [],
        ItemType.restaurant: data['restaurants'] ?? [],
        ItemType.attraction: data['attractions'] ?? [],
      };
      print('📥 Loaded favorites from cloud: ${state}');
    } catch (e) {
      print('❌ Error loading favorites: $e');
    }
  }

  // Save favorites to Firestore
  Future<void> _saveFavorites() async {
    if (_userId == null) return;
    
    await _service.saveFavorites(
      hotels: state[ItemType.hotel] ?? [],
      restaurants: state[ItemType.restaurant] ?? [],
      attractions: state[ItemType.attraction] ?? [],
    );
  }

  // Check if an item is in favorites
  bool isFavorite(String id, ItemType itemType) {
    final favorites = state[itemType] ?? [];
    return favorites.contains(id);
  }

  // Add or remove item from favorites (toggle)
  void toggleFavorite(String id, ItemType itemType) {
    // Create a copy of current state
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    
    if (favorites.contains(id)) {
      // Remove from favorites
      favorites.remove(id);
      if (_userId != null) {
        _service.removeFavorite(id, _getTypeString(itemType));
      }
    } else {
      // Add to favorites
      favorites.add(id);
      if (_userId != null) {
        _service.addFavorite(id, _getTypeString(itemType));
      }
    }
    
    // Update state
    currentFavorites[itemType] = favorites;
    state = currentFavorites;
  }

  // Helper to convert ItemType to string for Firestore
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

  // Add item to favorites (doesn't remove if already exists)
  void addToFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    
    // Only add if not already in favorites
    if (!favorites.contains(id)) {
      favorites.add(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
      
      // Persist to Firestore
      if (_userId != null) {
        _service.addFavorite(id, _getTypeString(itemType));
      }
    }
  }

  // Remove item from favorites
  void removeFromFavorites(String id, ItemType itemType) {
    final currentFavorites = Map<ItemType, List<String>>.from(state);
    final favorites = List<String>.from(currentFavorites[itemType] ?? []);
    
    // Only remove if in favorites
    if (favorites.contains(id)) {
      favorites.remove(id);
      currentFavorites[itemType] = favorites;
      state = currentFavorites;
      
      // Persist to Firestore
      if (_userId != null) {
        _service.removeFavorite(id, _getTypeString(itemType));
      }
    }
  }

  // Get all favorite IDs for a specific type
  List<String> getFavorites(ItemType itemType) {
    return state[itemType] ?? [];
  }
}
