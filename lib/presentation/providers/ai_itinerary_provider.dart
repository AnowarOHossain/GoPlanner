// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import models
import '../../data/models/itinerary_model.dart';
import '../../data/models/user_preferences_model.dart';
import '../../data/models/location_model.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/attraction_model.dart';
// Import services
import '../../core/services/gemini_api_service.dart';
// Import data providers
import './listings_provider.dart';

// Provider for the Gemini API service instance
final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiService();
});

// State class to manage AI itinerary generation state
class AIItineraryState {
  final bool isLoading;
  final ItineraryModel? itinerary;
  final String? error;
  final List<String> recommendations;

  AIItineraryState({
    this.isLoading = false,
    this.itinerary,
    this.error,
    this.recommendations = const [],
  });

  AIItineraryState copyWith({
    bool? isLoading,
    ItineraryModel? itinerary,
    String? error,
    List<String>? recommendations,
  }) {
    return AIItineraryState(
      isLoading: isLoading ?? this.isLoading,
      itinerary: itinerary ?? this.itinerary,
      error: error,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

// Notifier class to handle AI itinerary generation
class AIItineraryNotifier extends StateNotifier<AIItineraryState> {
  final GeminiApiService _geminiService;
  final Ref _ref;

  AIItineraryNotifier(this._geminiService, this._ref)
      : super(AIItineraryState());

  /// Generate an AI-powered itinerary
  Future<void> generateItinerary({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    String currency = 'BDT',
    List<String>? interests,
    String? travelStyle,
    List<String>? specificRequests,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get available data from providers - use valueOrNull to get data or empty list
      final hotelsAsync = _ref.read(bangladeshHotelsProvider);
      final restaurantsAsync = _ref.read(bangladeshRestaurantsProvider);
      final attractionsAsync = _ref.read(bangladeshAttractionsProvider);

      final hotels = hotelsAsync.asData?.value ?? <HotelModel>[];
      final restaurants = restaurantsAsync.asData?.value ?? <RestaurantModel>[];
      final attractions =
          await attractionsAsync.asData?.value ?? <AttractionModel>[];

      // Filter data for the destination
      final filteredHotels = hotels
          .where((h) =>
              h.location.city
                  .toLowerCase()
                  .contains(destination.toLowerCase()) ||
              h.division.toLowerCase().contains(destination.toLowerCase()))
          .toList();

      final filteredRestaurants = restaurants
          .where((r) =>
              r.location.city
                  .toLowerCase()
                  .contains(destination.toLowerCase()) ||
              r.division.toLowerCase().contains(destination.toLowerCase()))
          .toList();

      final filteredAttractions = attractions
          .where((a) =>
              a.location.city
                  .toLowerCase()
                  .contains(destination.toLowerCase()) ||
              a.division.toLowerCase().contains(destination.toLowerCase()))
          .toList();

      // Create location model
      final locationModel = filteredAttractions.isNotEmpty
          ? filteredAttractions.first.location
          : LocationModel(
              address: destination,
              city: destination,
              country: 'Bangladesh',
              latitude: 23.8103, // Default to Dhaka
              longitude: 90.4125,
              postalCode: '',
            );

      // Create user preferences
      final preferences = UserPreferencesModel(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        preferredCurrency: currency,
        favoriteCategories: interests ?? ['All'],
        travelStyle: TravelStyleModel(
          adventureLevel: travelStyle == 'Adventure' ? 'high' : 'medium',
          budgetLevel: budget < 5000
              ? 'budget'
              : budget < 15000
                  ? 'mid-range'
                  : 'luxury',
          pace: 'moderate',
          interests: interests ?? [],
        ),
        lastUpdated: DateTime.now(),
      );

      // Generate itinerary using Gemini API
      final itinerary = await _geminiService.generateItinerary(
        destination: locationModel,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        currency: currency,
        preferences: preferences,
        specificRequests: specificRequests,
        availableHotels: filteredHotels.isNotEmpty
            ? filteredHotels
            : hotels.take(10).toList(),
        availableRestaurants: filteredRestaurants.isNotEmpty
            ? filteredRestaurants
            : restaurants.take(10).toList(),
        availableAttractions: filteredAttractions.isNotEmpty
            ? filteredAttractions
            : attractions.take(10).toList(),
      );

      state =
          state.copyWith(isLoading: false, itinerary: itinerary, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate itinerary: ${e.toString()}',
      );
    }
  }

  /// Get travel recommendations
  Future<void> getTravelRecommendations({
    required String destination,
    required List<String> interests,
    String travelStyle = 'Balanced',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get available data
      final hotelsAsync = _ref.read(bangladeshHotelsProvider);
      final restaurantsAsync = _ref.read(bangladeshRestaurantsProvider);
      final attractionsAsync = _ref.read(bangladeshAttractionsProvider);

      final hotels = hotelsAsync.asData?.value ?? <HotelModel>[];
      final restaurants = restaurantsAsync.asData?.value ?? <RestaurantModel>[];
      final attractions =
          await attractionsAsync.asData?.value ?? <AttractionModel>[];

      // Filter data for destination
      final filteredAttractions = attractions
          .where((a) =>
              a.location.city
                  .toLowerCase()
                  .contains(destination.toLowerCase()) ||
              a.division.toLowerCase().contains(destination.toLowerCase()))
          .toList();

      final locationModel = filteredAttractions.isNotEmpty
          ? filteredAttractions.first.location
          : LocationModel(
              address: destination,
              city: destination,
              country: 'Bangladesh',
              latitude: 23.8103,
              longitude: 90.4125,
              postalCode: '',
            );

      final travelStyleModel = TravelStyleModel(
        adventureLevel: travelStyle == 'Adventure' ? 'high' : 'medium',
        budgetLevel: 'mid-range',
        pace: 'moderate',
        interests: interests,
      );

      // Get recommendations
      final recommendations = await _geminiService.getTravelRecommendations(
        destination: locationModel,
        travelStyle: travelStyleModel,
        interests: interests,
        availableHotels: hotels.take(10).toList(),
        availableRestaurants: restaurants.take(10).toList(),
        availableAttractions: attractions.take(10).toList(),
      );

      state = state.copyWith(
          isLoading: false, recommendations: recommendations, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get recommendations: ${e.toString()}',
      );
    }
  }

  /// Clear the current state
  void clearState() {
    state = AIItineraryState();
  }
}

// Provider for AI itinerary generation
final aiItineraryProvider =
    StateNotifierProvider<AIItineraryNotifier, AIItineraryState>((ref) {
  final geminiService = ref.watch(geminiApiServiceProvider);
  return AIItineraryNotifier(geminiService, ref);
});

// Provider for saved itineraries (for future implementation with local storage)
final savedItinerariesProvider =
    StateProvider<List<ItineraryModel>>((ref) => []);
