// Import dart JSON library for parsing data
import 'dart:convert';
// Import Flutter widgets for RangeValues
import 'package:flutter/material.dart';
// Import services to load asset files
import 'package:flutter/services.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import data models
import '../../data/models/hotel_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/attraction_model.dart';

// Provider to load Bangladesh hotels from JSON file
// This runs once and caches the result
final bangladeshHotelsProvider = FutureProvider<List<HotelModel>>((ref) async {
  try {
    // Load JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/data/bangladesh_hotels.json');
    // Parse JSON string to list
    final List<dynamic> jsonList = json.decode(jsonString);
    // Convert each JSON object to HotelModel
    return jsonList.map((json) => HotelModel.fromJson(json)).toList();
  } catch (e) {
    // Return empty list if there's an error
    return [];
  }
});

// Provider to load Bangladesh restaurants from JSON file
final bangladeshRestaurantsProvider = FutureProvider<List<RestaurantModel>>((ref) async {
  try {
    print(' Loading restaurant data...');
    // Load JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/data/bangladesh_restaurants.json');
    print(' JSON loaded, length: ${jsonString.length}');
    // Parse JSON string to list
    final List<dynamic> jsonList = json.decode(jsonString);
    print(' Parsed ${jsonList.length} restaurants');
    
    final List<RestaurantModel> restaurants = [];
    // Process each restaurant one by one
    for (int i = 0; i < jsonList.length; i++) {
      try {
        print(' Processing restaurant ${i + 1}...');
        final restaurant = RestaurantModel.fromJson(jsonList[i]);
        restaurants.add(restaurant);
        print(' Successfully added: ${restaurant.name}');
      } catch (e) {
        // Log error but continue with other restaurants
        print(' ERROR with restaurant ${i + 1}: $e');
        print(' Data: ${jsonList[i]}');
      }
    }
    
    print(' Final count: ${restaurants.length} restaurants loaded successfully');
    return restaurants;
  } catch (e) {
    print(' FATAL ERROR loading restaurants: $e');
    return [];
  }
});

// Provider for current hotels (returns AsyncValue for loading states)
final hotelsProvider = Provider<AsyncValue<List<HotelModel>>>((ref) {
  return ref.watch(bangladeshHotelsProvider);
});

// Provider for search query text
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for selected division filter (null means all divisions)
final selectedDivisionProvider = StateProvider<String?>((ref) => null);

// Provider for selected hotel type filter (null means all types)
final selectedHotelTypeProvider = StateProvider<String?>((ref) => null);

// Provider for price range filter (min and max price)
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(1000, 15000));

// Provider that combines all filters to give filtered hotel list
final filteredHotelsProvider = Provider<AsyncValue<List<HotelModel>>>((ref) {
  // Watch all filter providers
  final hotelsAsync = ref.watch(bangladeshHotelsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedDivision = ref.watch(selectedDivisionProvider);
  final selectedHotelType = ref.watch(selectedHotelTypeProvider);
  final priceRange = ref.watch(priceRangeProvider);
  
  return hotelsAsync.when(
    data: (hotels) {
      var filteredHotels = hotels;
      
      // Apply search filter - check if hotel name, city, or division matches
      if (searchQuery.isNotEmpty) {
        filteredHotels = filteredHotels.where((hotel) =>
          hotel.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          hotel.location.city.toLowerCase().contains(searchQuery.toLowerCase()) ||
          hotel.division.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }
      
      // Division filter
      if (selectedDivision != null && selectedDivision.isNotEmpty) {
        filteredHotels = filteredHotels.where((hotel) =>
          hotel.division.toLowerCase() == selectedDivision.toLowerCase()
        ).toList();
      }
      
      // Hotel type filter
      if (selectedHotelType != null && selectedHotelType.isNotEmpty) {
        filteredHotels = filteredHotels.where((hotel) =>
          hotel.hotelType.toLowerCase() == selectedHotelType.toLowerCase()
        ).toList();
      }
      
      // Price range filter
      filteredHotels = filteredHotels.where((hotel) =>
        hotel.pricePerNight >= priceRange.start && hotel.pricePerNight <= priceRange.end
      ).toList();
      
      return AsyncValue.data(filteredHotels);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Helper providers for filter options
final divisionsProvider = Provider<List<String>>((ref) {
  final hotelsAsync = ref.watch(bangladeshHotelsProvider);
  return hotelsAsync.when(
    data: (hotels) => hotels.map((hotel) => hotel.division).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final hotelTypesProvider = Provider<List<String>>((ref) {
  final hotelsAsync = ref.watch(bangladeshHotelsProvider);
  return hotelsAsync.when(
    data: (hotels) => hotels.map((hotel) => hotel.hotelType).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Restaurant Providers
// Current restaurants provider (async version)
final restaurantsProvider = Provider<AsyncValue<List<RestaurantModel>>>((ref) {
  return ref.watch(bangladeshRestaurantsProvider);
});

// Restaurant search provider
final restaurantSearchQueryProvider = StateProvider<String>((ref) => '');

// Restaurant filter providers
final selectedRestaurantDivisionProvider = StateProvider<String?>((ref) => null);
final selectedCuisineTypeProvider = StateProvider<String?>((ref) => null);
final selectedPriceRangeProvider = StateProvider<String?>((ref) => null);
final restaurantPriceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(500, 5000));

final filteredRestaurantsProvider = Provider<AsyncValue<List<RestaurantModel>>>((ref) {
  final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
  final searchQuery = ref.watch(restaurantSearchQueryProvider);
  final selectedDivision = ref.watch(selectedRestaurantDivisionProvider);
  final selectedCuisineType = ref.watch(selectedCuisineTypeProvider);
  final selectedPriceRange = ref.watch(selectedPriceRangeProvider);
  final priceRange = ref.watch(restaurantPriceRangeProvider);
  
  return restaurantsAsync.when(
    data: (restaurants) {
      var filteredRestaurants = restaurants;
      
      // Search filter
      if (searchQuery.isNotEmpty) {
        filteredRestaurants = filteredRestaurants.where((restaurant) =>
          restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          restaurant.location.city.toLowerCase().contains(searchQuery.toLowerCase()) ||
          restaurant.division.toLowerCase().contains(searchQuery.toLowerCase()) ||
          restaurant.cuisineType.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }
      
      // Division filter
      if (selectedDivision != null && selectedDivision.isNotEmpty) {
        filteredRestaurants = filteredRestaurants.where((restaurant) =>
          restaurant.division.toLowerCase() == selectedDivision.toLowerCase()
        ).toList();
      }
      
      // Cuisine type filter
      if (selectedCuisineType != null && selectedCuisineType.isNotEmpty) {
        filteredRestaurants = filteredRestaurants.where((restaurant) =>
          restaurant.cuisineType.toLowerCase().contains(selectedCuisineType.toLowerCase())
        ).toList();
      }
      
      // Price range filter (by category)
      if (selectedPriceRange != null && selectedPriceRange.isNotEmpty) {
        filteredRestaurants = filteredRestaurants.where((restaurant) =>
          restaurant.priceRange.toLowerCase() == selectedPriceRange.toLowerCase()
        ).toList();
      }
      
      // Numeric price range filter
      filteredRestaurants = filteredRestaurants.where((restaurant) =>
        restaurant.averageCostForTwo >= priceRange.start && restaurant.averageCostForTwo <= priceRange.end
      ).toList();
      
      return AsyncValue.data(filteredRestaurants);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Helper providers for restaurant filter options
final restaurantDivisionsProvider = Provider<List<String>>((ref) {
  final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
  return restaurantsAsync.when(
    data: (restaurants) => restaurants.map((restaurant) => restaurant.division).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final cuisineTypesProvider = Provider<List<String>>((ref) {
  final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
  return restaurantsAsync.when(
    data: (restaurants) => restaurants.map((restaurant) => restaurant.cuisineType).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final priceRangesProvider = Provider<List<String>>((ref) {
  final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
  return restaurantsAsync.when(
    data: (restaurants) => restaurants.map((restaurant) => restaurant.priceRange).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Bangladesh Attractions Provider
final bangladeshAttractionsProvider = FutureProvider<List<AttractionModel>>((ref) async {
  try {
    print(' Loading attraction data...');
    final String jsonString = await rootBundle.loadString('assets/data/bangladesh_attractions.json');
    print(' JSON loaded, length: ${jsonString.length}');
    final List<dynamic> jsonList = json.decode(jsonString);
    print(' Parsed ${jsonList.length} attractions');
    
    final List<AttractionModel> attractions = [];
    for (int i = 0; i < jsonList.length; i++) {
      try {
        print(' Processing attraction ${i + 1}...');
        final attraction = AttractionModel.fromJson(jsonList[i]);
        attractions.add(attraction);
        print(' Successfully added: ${attraction.name}');
      } catch (e) {
        print(' ERROR with attraction ${i + 1}: $e');
        print(' Data: ${jsonList[i]}');
      }
    }
    
    print(' Final count: ${attractions.length} attractions loaded successfully');
    return attractions;
  } catch (e) {
    print(' FATAL ERROR loading attractions: $e');
    return [];
  }
});

// Attraction search and filter providers
final attractionSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedAttractionDivisionProvider = StateProvider<String?>((ref) => null);
final selectedAttractionCategoryProvider = StateProvider<String?>((ref) => null);
final selectedHistoricalPeriodProvider = StateProvider<String?>((ref) => null);

final filteredAttractionsProvider = Provider<AsyncValue<List<AttractionModel>>>((ref) {
  final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
  final searchQuery = ref.watch(attractionSearchQueryProvider);
  final selectedDivision = ref.watch(selectedAttractionDivisionProvider);
  final selectedCategory = ref.watch(selectedAttractionCategoryProvider);
  final selectedPeriod = ref.watch(selectedHistoricalPeriodProvider);
  
  return attractionsAsync.when(
    data: (attractions) {
      var filteredAttractions = attractions;
      
      // Search filter
      if (searchQuery.isNotEmpty) {
        filteredAttractions = filteredAttractions.where((attraction) =>
          attraction.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          attraction.location.city.toLowerCase().contains(searchQuery.toLowerCase()) ||
          attraction.division.toLowerCase().contains(searchQuery.toLowerCase()) ||
          attraction.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          attraction.subcategory.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }
      
      // Division filter
      if (selectedDivision != null && selectedDivision.isNotEmpty) {
        filteredAttractions = filteredAttractions.where((attraction) =>
          attraction.division.toLowerCase() == selectedDivision.toLowerCase()
        ).toList();
      }
      
      // Category filter
      if (selectedCategory != null && selectedCategory.isNotEmpty) {
        filteredAttractions = filteredAttractions.where((attraction) =>
          attraction.category.toLowerCase() == selectedCategory.toLowerCase()
        ).toList();
      }
      
      // Historical period filter
      if (selectedPeriod != null && selectedPeriod.isNotEmpty) {
        filteredAttractions = filteredAttractions.where((attraction) =>
          attraction.historicalPeriod.toLowerCase() == selectedPeriod.toLowerCase()
        ).toList();
      }
      
      return AsyncValue.data(filteredAttractions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Helper providers for attraction filter options
final attractionDivisionsProvider = Provider<List<String>>((ref) {
  final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
  return attractionsAsync.when(
    data: (attractions) => attractions.map((attraction) => attraction.division).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final attractionCategoriesProvider = Provider<List<String>>((ref) {
  final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
  return attractionsAsync.when(
    data: (attractions) => attractions.map((attraction) => attraction.category).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final historicalPeriodsProvider = Provider<List<String>>((ref) {
  final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
  return attractionsAsync.when(
    data: (attractions) => attractions.map((attraction) => attraction.historicalPeriod).toSet().toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Favorites Providers
final favoriteHotelsProvider = StateProvider<Set<String>>((ref) => <String>{});
final favoriteRestaurantsProvider = StateProvider<Set<String>>((ref) => <String>{});
final favoriteAttractionsProvider = StateProvider<Set<String>>((ref) => <String>{});

// Budget/Cart Providers
class BudgetItem {
  final String id;
  final String name;
  final String type; // hotel, restaurant, attraction
  final double price;
  final String currency;
  final String imageUrl;
  final String location;
  final int quantity;

  const BudgetItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.location,
    this.quantity = 1,
  });

  BudgetItem copyWith({
    String? id,
    String? name,
    String? type,
    double? price,
    String? currency,
    String? imageUrl,
    String? location,
    int? quantity,
  }) {
    return BudgetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
    );
  }
}

final budgetItemsProvider = StateProvider<List<BudgetItem>>((ref) => []);

final totalBudgetProvider = Provider<double>((ref) {
  final items = ref.watch(budgetItemsProvider);
  return items.fold(0.0, (total, item) => total + (item.price * item.quantity));
});

// Helper providers for combined favorites
final allFavoritesProvider = Provider<Map<String, List<dynamic>>>((ref) {
  final favoriteHotelIds = ref.watch(favoriteHotelsProvider);
  final favoriteRestaurantIds = ref.watch(favoriteRestaurantsProvider);
  final favoriteAttractionIds = ref.watch(favoriteAttractionsProvider);
  
  final hotelsAsync = ref.watch(bangladeshHotelsProvider);
  final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
  final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
  
  final Map<String, List<dynamic>> favorites = {
    'hotels': [],
    'restaurants': [],
    'attractions': [],
  };
  
  hotelsAsync.whenData((hotels) {
    favorites['hotels'] = hotels.where((hotel) => favoriteHotelIds.contains(hotel.id)).toList();
  });
  
  restaurantsAsync.whenData((restaurants) {
    favorites['restaurants'] = restaurants.where((restaurant) => favoriteRestaurantIds.contains(restaurant.id)).toList();
  });
  
  attractionsAsync.whenData((attractions) {
    favorites['attractions'] = attractions.where((attraction) => favoriteAttractionIds.contains(attraction.id)).toList();
  });
  
  return favorites;
});