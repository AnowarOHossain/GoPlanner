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

// Service to interact with Google Gemini AI API
// This generates personalized travel itineraries using AI
class GeminiApiService {
  static const String _baseUrl = AppConstants.geminiApiBaseUrl;
  static const String _apiKey = AppConstants.geminiApiKey;

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
  }) async {
    try {
      // Build AI prompt for recommendations
      final prompt = _buildRecommendationPrompt(
        destination: destination,
        travelStyle: travelStyle,
        interests: interests,
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
  }) async {
    try {
      final prompt = _buildOptimizationPrompt(
        currentItinerary: currentItinerary,
        feedback: feedback,
        preferences: preferences,
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
    final url = Uri.parse('$_baseUrl/gemini-pro:generateContent?key=$_apiKey');
    
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
  }) {
    final duration = endDate.difference(startDate).inDays + 1;
    
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

REQUIREMENTS:
1. Provide a day-by-day breakdown with specific times
2. Include hotels, restaurants, and attractions with estimated costs
3. Stay within the specified budget
4. Consider travel time between locations
5. Match the specified travel style and pace
6. Include variety in activities based on interests

FORMAT THE RESPONSE AS A VALID JSON OBJECT WITH THIS STRUCTURE:
{
  "title": "Trip title",
  "description": "Brief description",
  "dayPlans": [
    {
      "dayNumber": 1,
      "date": "YYYY-MM-DD",
      "activities": [
        {
          "id": "unique_id",
          "name": "Activity name",
          "type": "hotel|restaurant|attraction",
          "startTime": "HH:MM",
          "endTime": "HH:MM",
          "cost": 0.0,
          "description": "Activity description",
          "location": {
            "latitude": 0.0,
            "longitude": 0.0,
            "address": "Full address",
            "city": "${destination.city}",
            "country": "${destination.country}"
          },
          "duration": 120
        }
      ],
      "notes": "Day-specific notes"
    }
  ],
  "tags": ["tag1", "tag2"],
  "totalEstimatedCost": 0.0
}

IMPORTANT: Return ONLY the JSON object, no additional text or explanation.
''';
  }

  String _buildRecommendationPrompt({
    required LocationModel destination,
    required TravelStyleModel travelStyle,
    required List<String> interests,
  }) {
    return '''
Provide 10 personalized travel recommendations for ${destination.city}, ${destination.country}.

TRAVELER PROFILE:
- Adventure Level: ${travelStyle.adventureLevel}
- Budget Level: ${travelStyle.budgetLevel}
- Group Preference: ${travelStyle.preferGroupTravel ? 'Group' : 'Solo'}
- Interests: ${interests.join(', ')}
- Pace: ${travelStyle.pace}

REQUIREMENTS:
1. Mix of hotels, restaurants, and attractions
2. Match the traveler's interests and style
3. Include hidden gems and local favorites
4. Provide brief explanations for each recommendation

FORMAT: Return as a JSON array of strings, each containing a recommendation with name and brief description.
Example: ["Hotel ABC - Luxury boutique hotel in city center with rooftop pool", "Restaurant XYZ - Authentic local cuisine with vegetarian options"]

Return ONLY the JSON array, no additional text.
''';
  }

  String _buildOptimizationPrompt({
    required ItineraryModel currentItinerary,
    required String feedback,
    required UserPreferencesModel preferences,
  }) {
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

REQUIREMENTS:
1. Address the specific feedback provided
2. Maintain the same date range and budget constraints
3. Keep the overall structure but make improvements
4. Ensure logical flow and timing between activities

Return the optimized itinerary in the same JSON format as the original.
Return ONLY the JSON object, no additional text.
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