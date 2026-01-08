// Import JSON library for API communication
import 'dart:convert';
// Import HTTP library for making API calls
import 'package:http/http.dart' as http;
// Import app constants
import '../../core/constants/app_constants.dart';
// Import data models
import '../../data/models/itinerary_model.dart';
import '../../data/models/user_preferences_model.dart';
import '../../data/models/location_model.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/attraction_model.dart';

// Service to interact with Google Gemini AI API
// This generates personalized travel itineraries using AI
class GeminiApiService {
  static const String _baseUrl = AppConstants.geminiApiBaseUrl;
  static String get _apiKey => AppConstants.geminiApiKey;

  /// Generate a personalized travel itinerary using Google Gemini AI
  /// Takes destination, dates, budget, and user preferences
  /// Returns a complete day-by-day itinerary
  Future<ItineraryModel> generateItinerary({
    required LocationModel destination,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required String currency,
    required UserPreferencesModel preferences,
    List<String>? specificRequests,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) async {
    try {
      // Build AI prompt with all the information
      final prompt = _buildItineraryPrompt(
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        currency: currency,
        preferences: preferences,
        specificRequests: specificRequests,
        availableHotels: availableHotels,
        availableRestaurants: availableRestaurants,
        availableAttractions: availableAttractions,
      );

      // Call Gemini API
      final response = await _callGeminiAPI(prompt);
      
      // Parse AI response into itinerary model
      return _parseItineraryResponse(response, destination, startDate, endDate, budget, currency);
    } catch (e) {
      throw GeminiApiException('Failed to generate itinerary: ${e.toString()}');
    }
  }

  /// Get travel recommendations based on user preferences
  /// Returns list of suggested activities and places
  Future<List<String>> getTravelRecommendations({
    required LocationModel destination,
    required TravelStyleModel travelStyle,
    required List<String> interests,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) async {
    try {
      // Build AI prompt for recommendations
      final prompt = _buildRecommendationPrompt(
        destination: destination,
        travelStyle: travelStyle,
        interests: interests,
        availableHotels: availableHotels,
        availableRestaurants: availableRestaurants,
        availableAttractions: availableAttractions,
      );

      // Call Gemini API
      final response = await _callGeminiAPI(prompt);
      
      // Parse AI response into list of recommendations
      return _parseRecommendationsResponse(response);
    } catch (e) {
      throw GeminiApiException('Failed to get recommendations: ${e.toString()}');
    }
  }

  /// Optimize existing itinerary based on user feedback
  Future<ItineraryModel> optimizeItinerary({
    required ItineraryModel currentItinerary,
    required String feedback,
    required UserPreferencesModel preferences,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) async {
    try {
      final prompt = _buildOptimizationPrompt(
        currentItinerary: currentItinerary,
        feedback: feedback,
        preferences: preferences,
        availableHotels: availableHotels,
        availableRestaurants: availableRestaurants,
        availableAttractions: availableAttractions,
      );

      final response = await _callGeminiAPI(prompt);
      return _parseItineraryResponse(
        response,
        currentItinerary.destination,
        currentItinerary.startDate,
        currentItinerary.endDate,
        currentItinerary.totalBudget,
        currentItinerary.currency,
      );
    } catch (e) {
      throw GeminiApiException('Failed to optimize itinerary: ${e.toString()}');
    }
  }

  // Private methods for API communication
  Future<String> _callGeminiAPI(String prompt) async {
    final url = Uri.parse('$_baseUrl/gemini-1.5-flash:generateContent?key=$_apiKey');
    
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 8192,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw GeminiApiException('API request failed: ${response.statusCode} - ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    
    if (responseData['candidates'] == null || responseData['candidates'].isEmpty) {
      throw const GeminiApiException('No response from Gemini API');
    }

    return responseData['candidates'][0]['content']['parts'][0]['text'];
  }

  String _buildItineraryPrompt({
    required LocationModel destination,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required String currency,
    required UserPreferencesModel preferences,
    List<String>? specificRequests,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) {
    final duration = endDate.difference(startDate).inDays + 1;

    final availableDataSection = _buildAvailableDataSection(
      destination: destination,
      hotels: availableHotels,
      restaurants: availableRestaurants,
      attractions: availableAttractions,
    );
    
    return '''
Create a detailed $duration-day travel itinerary for ${destination.city}, ${destination.country}.

TRIP DETAILS:
- Dates: ${startDate.toIso8601String().split('T')[0]} to ${endDate.toIso8601String().split('T')[0]}
- Budget: $currency $budget
- Group: ${preferences.travelStyle.preferGroupTravel ? 'Group' : 'Solo'} travel
- Adventure Level: ${preferences.travelStyle.adventureLevel}
- Budget Level: ${preferences.travelStyle.budgetLevel}
- Pace: ${preferences.travelStyle.pace}
- Interests: ${preferences.travelStyle.interests.join(', ')}

PREFERENCES:
- Dietary Restrictions: ${preferences.dietaryRestrictions.join(', ')}
- Favorite Categories: ${preferences.favoriteCategories.join(', ')}
${specificRequests != null && specificRequests.isNotEmpty ? '- Specific Requests: ${specificRequests.join(', ')}' : ''}

$availableDataSection

REQUIREMENTS:
1. Provide a day-by-day breakdown with specific times
2. Include hotels, restaurants, and attractions with estimated costs
3. Stay within the specified budget
4. Consider travel time between locations
5. Match the specified travel style and pace
6. Include variety in activities based on interests
7. If AVAILABLE DATA is provided, prefer using those items and their IDs
8. For each itinerary item: set `itemId` to a real dataset id when possible; otherwise use a unique `custom_...` id

FORMAT THE RESPONSE AS A VALID JSON OBJECT WITH THIS EXACT STRUCTURE:
{
  "title": "Trip title",
  "description": "Brief description",
  "dayPlans": [
    {
      "id": "day_001",
      "dayNumber": 1,
      "date": "YYYY-MM-DD",
      "dailyBudget": 0.0,
      "items": [
        {
          "id": "item_001",
          "itemId": "attr_001",
          "type": "hotel|restaurant|attraction",
          "name": "Place name",
          "location": {
            "latitude": 0.0,
            "longitude": 0.0,
            "address": "Full address",
            "city": "${destination.city}",
            "country": "${destination.country}"
          },
          "startTime": "YYYY-MM-DDTHH:MM:SS",
          "endTime": "YYYY-MM-DDTHH:MM:SS",
          "estimatedCost": 0.0,
          "currency": "$currency",
          "notes": "Optional notes",
          "isBooked": false
        }
      ],
      "notes": "Optional day notes"
    }
  ],
  "tags": ["tag1", "tag2"]
}

IMPORTANT: Return ONLY the JSON object, no additional text or explanation.
''';
  }

  String _buildRecommendationPrompt({
    required LocationModel destination,
    required TravelStyleModel travelStyle,
    required List<String> interests,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) {
    final availableDataSection = _buildAvailableDataSection(
      destination: destination,
      hotels: availableHotels,
      restaurants: availableRestaurants,
      attractions: availableAttractions,
    );

    return '''
Provide 10 personalized travel recommendations for ${destination.city}, ${destination.country}.

TRAVELER PROFILE:
- Adventure Level: ${travelStyle.adventureLevel}
- Budget Level: ${travelStyle.budgetLevel}
- Group Preference: ${travelStyle.preferGroupTravel ? 'Group' : 'Solo'}
- Interests: ${interests.join(', ')}
- Pace: ${travelStyle.pace}

$availableDataSection

REQUIREMENTS:
1. Mix of hotels, restaurants, and attractions
2. Match the traveler's interests and style
3. Include hidden gems and local favorites
4. Provide brief explanations for each recommendation
5. If AVAILABLE DATA is provided, prefer recommending those specific items (include their id in the text)

FORMAT: Return as a JSON array of strings, each containing a recommendation with name and brief description.
Example: ["Hotel ABC - Luxury boutique hotel in city center with rooftop pool", "Restaurant XYZ - Authentic local cuisine with vegetarian options"]

Return ONLY the JSON array, no additional text.
''';
  }

  String _buildOptimizationPrompt({
    required ItineraryModel currentItinerary,
    required String feedback,
    required UserPreferencesModel preferences,
    List<HotelModel>? availableHotels,
    List<RestaurantModel>? availableRestaurants,
    List<AttractionModel>? availableAttractions,
  }) {
    final availableDataSection = _buildAvailableDataSection(
      destination: currentItinerary.destination,
      hotels: availableHotels,
      restaurants: availableRestaurants,
      attractions: availableAttractions,
    );

    return '''
Optimize the following travel itinerary based on user feedback.

CURRENT ITINERARY:
${jsonEncode(currentItinerary.toJson())}

USER FEEDBACK:
$feedback

PREFERENCES:
- Adventure Level: ${preferences.travelStyle.adventureLevel}
- Budget Level: ${preferences.travelStyle.budgetLevel}
- Interests: ${preferences.travelStyle.interests.join(', ')}
- Dietary Restrictions: ${preferences.dietaryRestrictions.join(', ')}

$availableDataSection

REQUIREMENTS:
1. Address the specific feedback provided
2. Maintain the same date range and budget constraints
3. Keep the overall structure but make improvements
4. Ensure logical flow and timing between activities
5. If AVAILABLE DATA is provided, prefer using those item IDs where applicable

Return the optimized itinerary in the same JSON format as the original.
Return ONLY the JSON object, no additional text.
''';
  }

  String _buildAvailableDataSection({
    required LocationModel destination,
    List<HotelModel>? hotels,
    List<RestaurantModel>? restaurants,
    List<AttractionModel>? attractions,
  }) {
    final hasAny =
        (hotels != null && hotels.isNotEmpty) || (restaurants != null && restaurants.isNotEmpty) || (attractions != null && attractions.isNotEmpty);
    if (!hasAny) return '';

    final query = destination.city.trim().toLowerCase();

    List<T> pickRelevant<T>(List<T> items, bool Function(T item) matches) {
      final relevant = items.where(matches).toList();
      final source = relevant.isNotEmpty ? relevant : items;
      return source.take(12).toList();
    }

    final pickedHotels = hotels == null
        ? <HotelModel>[]
        : pickRelevant<HotelModel>(
            hotels,
            (h) =>
                h.location.city.toLowerCase().contains(query) ||
                h.district.toLowerCase().contains(query) ||
                h.division.toLowerCase().contains(query),
          );

    final pickedRestaurants = restaurants == null
        ? <RestaurantModel>[]
        : pickRelevant<RestaurantModel>(
            restaurants,
            (r) =>
                r.location.city.toLowerCase().contains(query) ||
                r.district.toLowerCase().contains(query) ||
                r.division.toLowerCase().contains(query),
          );

    final pickedAttractions = attractions == null
        ? <AttractionModel>[]
        : pickRelevant<AttractionModel>(
            attractions,
            (a) =>
                a.location.city.toLowerCase().contains(query) ||
                a.district.toLowerCase().contains(query) ||
                a.division.toLowerCase().contains(query),
          );

    Map<String, dynamic> hotelToPromptJson(HotelModel h) => {
          'id': h.id,
          'name': h.name,
          'division': h.division,
          'district': h.district,
          'rating': h.rating,
          'reviewCount': h.reviewCount,
          'pricePerNight': h.pricePerNight,
          'currency': h.currency,
          'amenities': h.amenities.take(6).toList(),
          'location': h.location.toJson(),
        };

    Map<String, dynamic> restaurantToPromptJson(RestaurantModel r) => {
          'id': r.id,
          'name': r.name,
          'division': r.division,
          'district': r.district,
          'rating': r.rating,
          'reviewCount': r.reviewCount,
          'priceRange': r.priceRange,
          'averageCostForTwo': r.averageCostForTwo,
          'currency': r.currency,
          'cuisineType': r.cuisineType,
          'popularDishes': r.popularDishes.take(6).toList(),
          'location': r.location.toJson(),
        };

    Map<String, dynamic> attractionToPromptJson(AttractionModel a) => {
          'id': a.id,
          'name': a.name,
          'division': a.division,
          'district': a.district,
          'rating': a.rating,
          'reviewCount': a.reviewCount,
          'entryFee': a.entryFee,
          'currency': a.currency,
          'category': a.category,
          'subcategory': a.subcategory,
          'highlights': a.highlights.take(6).toList(),
          'location': a.location.toJson(),
        };

    final payload = {
      'destinationQuery': destination.city,
      'hotels': pickedHotels.map(hotelToPromptJson).toList(),
      'restaurants': pickedRestaurants.map(restaurantToPromptJson).toList(),
      'attractions': pickedAttractions.map(attractionToPromptJson).toList(),
    };

    return '''
AVAILABLE DATA (prefer using these exact places and ids when possible):
${jsonEncode(payload)}
''';
  }

  ItineraryModel _parseItineraryResponse(
    String response,
    LocationModel destination,
    DateTime startDate,
    DateTime endDate,
    double budget,
    String currency,
  ) {
    try {
      // Clean the response to ensure it's valid JSON
      final cleanResponse = response.trim();
      final jsonData = jsonDecode(cleanResponse);
      
      // Parse the JSON into an ItineraryModel
      return ItineraryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: jsonData['title'] ?? 'AI Generated Itinerary',
        description: jsonData['description'] ?? '',
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        totalBudget: budget,
        currency: currency,
        dayPlans: (jsonData['dayPlans'] as List<dynamic>?)
            ?.map((dayData) => DayPlanModel.fromJson(dayData))
            .toList() ?? [],
        tags: List<String>.from(jsonData['tags'] ?? []),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),

      );
    } catch (e) {
      throw GeminiApiException('Failed to parse itinerary response: ${e.toString()}');
    }
  }

  List<String> _parseRecommendationsResponse(String response) {
    try {
      final jsonData = jsonDecode(response.trim());
      return List<String>.from(jsonData);
    } catch (e) {
      throw GeminiApiException('Failed to parse recommendations response: ${e.toString()}');
    }
  }
}

class GeminiApiException implements Exception {
  final String message;
  
  const GeminiApiException(this.message);
  
  @override
  String toString() => 'GeminiApiException: $message';
}