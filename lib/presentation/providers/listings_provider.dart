import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/hotel_model.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/attraction_model.dart';

part 'listings_provider.g.dart';

// Hotels Provider
@riverpod
class HotelsNotifier extends _$HotelsNotifier {
  @override
  AsyncValue<List<HotelModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadHotels({
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      final hotels = await _fetchHotels(
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        category: category,
      );
      
      state = AsyncValue.data(hotels);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<HotelModel>> _fetchHotels({
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
  }) async {
    // TODO: Implement actual API call to Firebase/JSON
    // This is mock data for demonstration
    return [
      // Mock hotel data will be loaded from JSON or Firebase
    ];
  }

  void searchHotels(String query) {
    if (state.hasValue) {
      final filteredHotels = state.value!.where((hotel) {
        return hotel.name.toLowerCase().contains(query.toLowerCase()) ||
               hotel.location.city.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      state = AsyncValue.data(filteredHotels);
    }
  }
}

// Restaurants Provider
@riverpod
class RestaurantsNotifier extends _$RestaurantsNotifier {
  @override
  AsyncValue<List<RestaurantModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadRestaurants({
    String? city,
    String? cuisine,
    String? priceRange,
    double? minRating,
    List<String>? dietaryOptions,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      final restaurants = await _fetchRestaurants(
        city: city,
        cuisine: cuisine,
        priceRange: priceRange,
        minRating: minRating,
        dietaryOptions: dietaryOptions,
      );
      
      state = AsyncValue.data(restaurants);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<RestaurantModel>> _fetchRestaurants({
    String? city,
    String? cuisine,
    String? priceRange,
    double? minRating,
    List<String>? dietaryOptions,
  }) async {
    // TODO: Implement actual API call to Firebase/JSON
    return [];
  }

  void searchRestaurants(String query) {
    if (state.hasValue) {
      final filteredRestaurants = state.value!.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
               restaurant.cuisine.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      state = AsyncValue.data(filteredRestaurants);
    }
  }
}

// Attractions Provider
@riverpod
class AttractionsNotifier extends _$AttractionsNotifier {
  @override
  AsyncValue<List<AttractionModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadAttractions({
    String? city,
    String? category,
    double? maxPrice,
    double? minRating,
    bool? isFree,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      final attractions = await _fetchAttractions(
        city: city,
        category: category,
        maxPrice: maxPrice,
        minRating: minRating,
        isFree: isFree,
      );
      
      state = AsyncValue.data(attractions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<AttractionModel>> _fetchAttractions({
    String? city,
    String? category,
    double? maxPrice,
    double? minRating,
    bool? isFree,
  }) async {
    // TODO: Implement actual API call to Firebase/JSON
    return [];
  }

  void searchAttractions(String query) {
    if (state.hasValue) {
      final filteredAttractions = state.value!.where((attraction) {
        return attraction.name.toLowerCase().contains(query.toLowerCase()) ||
               attraction.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      state = AsyncValue.data(filteredAttractions);
    }
  }
}

// Combined search provider
@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
    
    // Trigger searches in all providers
    ref.read(hotelsNotifierProvider.notifier).searchHotels(query);
    ref.read(restaurantsNotifierProvider.notifier).searchRestaurants(query);
    ref.read(attractionsNotifierProvider.notifier).searchAttractions(query);
  }

  void clearSearch() {
    state = '';
    // Reload original data
    ref.read(hotelsNotifierProvider.notifier).loadHotels();
    ref.read(restaurantsNotifierProvider.notifier).loadRestaurants();
    ref.read(attractionsNotifierProvider.notifier).loadAttractions();
  }
}