import 'package:flutter/services.dart' show rootBundle;
// Simplified Gemini API Service for free tier usage
// Returns plain English suggestions instead of complex JSON

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

/// Simplified service for AI travel suggestions
/// Optimized for Gemini free tier - uses plain text responses
class GeminiSimpleService {
      // Timestamp of the last API call
      DateTime? _lastApiCallTime;
      // Minimum delay between API calls (in seconds)
      static const int _minDelaySeconds = 2;
    // Helper to load and filter data from ai_suggestions.json by city (if possible)
    Future<Map<String, List<Map<String, dynamic>>>> _loadSuggestionsData() async {
      final dataString = await rootBundle.loadString('assets/data/ai_suggestions.json');
      final Map<String, dynamic> data = jsonDecode(dataString);
      return {
        'hotels': (data['hotels'] as List).cast<Map<String, dynamic>>(),
        'restaurants': (data['restaurants'] as List).cast<Map<String, dynamic>>(),
        'attractions': (data['attractions'] as List).cast<Map<String, dynamic>>()
      };
    }

    // Helper to filter by city name (case-insensitive, partial match)
    List<Map<String, dynamic>> _filterByCity(List<Map<String, dynamic>> items, String city) {
      if (city.trim().isEmpty) return items;
      final cityLower = city.toLowerCase();
      return items.where((item) {
        final name = (item['name'] ?? '').toString().toLowerCase();
        return name.contains(cityLower) || cityLower.contains(name);
      }).toList();
    }
  static const String _baseUrl = AppConstants.geminiApiBaseUrl;
  static String get _apiKey => AppConstants.geminiApiKey;

  /// Generate travel suggestions in plain English
  /// Returns a formatted text with hotel, restaurant, and attraction recommendations
  Future<String> getTravelSuggestions({
    required String destination,
    required int days,
    required double budget,
    required String currency,
    List<String>? interests,
    String? travelStyle,
  }) async {
    final interestsText = interests?.join(', ') ?? 'sightseeing, local culture';
    final styleText = travelStyle ?? 'balanced';


    // Load simplified data from ai_suggestions.json
    final suggestionsData = await _loadSuggestionsData();
    final hotels = _filterByCity(suggestionsData['hotels'] ?? [], destination);
    final restaurants = _filterByCity(suggestionsData['restaurants'] ?? [], destination);
    final attractions = _filterByCity(suggestionsData['attractions'] ?? [], destination);

    print('Hotels loaded: ${hotels.length}');
    print('Restaurants loaded: ${restaurants.length}');
    print('Attractions loaded: ${attractions.length}');

    // Budget filtering for hotels (if pricePerNight exists)
    List<Map<String, dynamic>> filteredHotels = hotels.where((h) {
      final price = h['pricePerNight'] ?? h['price_range'];
      if (price is num && price > 0 && budget > 0) {
        return price <= (budget / (days > 0 ? days : 1));
      }
      return true;
    }).toList();

    String hotelList = filteredHotels.isNotEmpty
      ? filteredHotels.take(15).map((h) => '${h['name']} (approx. ${h['pricePerNight'] ?? h['price_range'] ?? 'N/A'} $currency/night)').join('; ')
      : 'not found';

    String restaurantList = restaurants.isNotEmpty
      ? restaurants.take(15).map((r) => '${r['name']} (avg. cost for two: ${r['averageCostForTwo'] ?? 'N/A'} $currency)').join('; ')
      : 'not found';
    String attractionList = attractions.isNotEmpty
      ? attractions.take(15).map((a) => '${a['name']} (entry fee: ${a['entryFee'] ?? 'N/A'} $currency)').join('; ')
      : 'not found';

    final prompt = '''
  You are a helpful travel assistant for Bangladesh tourism. Use ONLY the following data for your suggestions. If any category is 'not found', do not suggest anything for that category.

  Hotels: $hotelList
  Restaurants: $restaurantList
  Attractions: $attractionList

  USER REQUEST:
  - Destination: $destination, Bangladesh
  - Trip Duration: $days day(s)
  - Budget: $currency $budget
  - Interests: $interestsText
  - Travel Style: $styleText

  INSTRUCTIONS:
  1. Suggest 2-3 hotels within budget (name, approx. price per night) if available, otherwise say 'not found'.
  2. Suggest 3-4 restaurants (name, cuisine type, avg. cost for two) if available, otherwise say 'not found'.
  3. Suggest 4-5 attractions/activities (name, entry fee if any) if available, otherwise say 'not found'.
  4. Provide a simple day-wise outline using only the above data.
  5. Calculate estimated total cost if possible.
  6. If budget is insufficient, clearly state:
     - What can be done within budget
     - How much additional budget is recommended for a complete experience

  Keep your response concise and practical. Use bullet points.
  Do NOT use JSON format - write in plain, readable English.
  ''';

    // Debugging prompt construction
    print('Prompt constructed:\n$prompt');

    try {
      final response = await _callGeminiAPI(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to get suggestions: ${e.toString()}');
    }
  }

  /// Get quick recommendations for a specific category
  Future<String> getQuickRecommendations({
    required String destination,
    required String category, // 'hotels', 'restaurants', 'attractions'
    required double budget,
    required String currency,
  }) async {

    // Use only ai_suggestions.json for recommendations
    final suggestionsData = await _loadSuggestionsData();
    List<Map<String, dynamic>> data = _filterByCity(suggestionsData[category] ?? [], destination);
    String dataList = data.isNotEmpty
        ? data.take(6).map((item) {
            String name = item['name'] ?? 'Unknown';
            String desc = '';
            String price = 'N/A';
            if (category == 'hotels') {
              price = item['pricePerNight']?.toString() ?? 'N/A';
              desc = 'Hotel';
            } else if (category == 'restaurants') {
              price = item['averageCostForTwo']?.toString() ?? 'N/A';
              desc = 'Restaurant';
            } else if (category == 'attractions') {
              price = item['entryFee']?.toString() ?? 'N/A';
              desc = 'Attraction';
            }
            return '$name ($desc, approx. $price $currency)';
          }).join(', ')
        : 'not found';

    final prompt = '''
You are a Bangladesh travel expert. Use ONLY the following data for $category recommendations. If 'not found', do not suggest anything for that category.

$category: $dataList

Destination: $destination, Bangladesh
Budget: $currency $budget
Category: $category

Provide up to 6 $category options with:
- Name and brief description
- Approximate cost
- Why it's recommended (if available)

If 'not found', say 'not found'.
Keep it brief and helpful. Use bullet points. No JSON.
''';

    try {
      final response = await _callGeminiAPI(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to get recommendations: ${e.toString()}');
    }
  }

  /// Generate a simple day plan
  Future<String> getDayPlan({
    required String destination,
    required int dayNumber,
    required int totalDays,
    required double dailyBudget,
    required String currency,
    List<String>? preferences,
  }) async {
    final prefsText = preferences?.join(', ') ?? 'general sightseeing';
    
    final prompt = '''
Create a simple day plan for Day $dayNumber of $totalDays in $destination, Bangladesh.

Daily Budget: $currency $dailyBudget
Preferences: $prefsText

Include:
- Morning activity
- Lunch suggestion
- Afternoon activity  
- Dinner suggestion
- Estimated costs for each

Keep it practical and achievable. Plain English, bullet points.
''';

    try {
      final response = await _callGeminiAPI(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to get day plan: ${e.toString()}');
    }
  }

  // Private method to call Gemini API
  Future<String> _callGeminiAPI(String prompt) async {
    // Throttle requests: ensure at least _minDelaySeconds between calls
    final now = DateTime.now();
    if (_lastApiCallTime != null) {
      final diff = now.difference(_lastApiCallTime!).inSeconds;
      if (diff < _minDelaySeconds) {
        final wait = _minDelaySeconds - diff;
        throw Exception('You are sending requests too quickly. Please wait ${wait + 1} second(s) and try again.');
      }
    }
    _lastApiCallTime = now;
    // Use gemini-2.5-flash for current compatibility
    final url = Uri.parse('$_baseUrl/gemini-2.5-flash:generateContent?key=$_apiKey');

    // Debug: Print API key status (not the actual key)
    print('API Key loaded: ${_apiKey.isNotEmpty ? "Yes (${_apiKey.length} chars)" : "NO - MISSING!"}');
    print('API URL: $_baseUrl/gemini-2.5-flash:generateContent');
    
    if (_apiKey.isEmpty) {
      throw Exception('API key is missing! Check your .env file.');
    }
    
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
        'maxOutputTokens': 1024, // Smaller for free tier
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 60));

      print('API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 429) {
        throw Exception('429: Rate limit exceeded. Please wait a moment.');
      }
      
      if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
        throw Exception('400: Invalid request - ${response.body}');
      }
      
      if (response.statusCode == 403) {
        print('Forbidden: ${response.body}');
        throw Exception('403: API key invalid or disabled');
      }

      if (response.statusCode != 200) {
        print('Error Response: ${response.body}');
        throw Exception('API error ${response.statusCode}: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      
      // Extract and concatenate all text parts from response
      if (responseData['candidates'] != null &&
          responseData['candidates'].isNotEmpty) {
        final candidate = responseData['candidates'][0];
        if (candidate['content'] != null &&
            candidate['content']['parts'] != null &&
            candidate['content']['parts'].isNotEmpty) {
          // Concatenate all text parts
          final parts = candidate['content']['parts'];
          final buffer = StringBuffer();
          for (final part in parts) {
            if (part['text'] != null) buffer.write(part['text']);
          }
          final result = buffer.toString().trim();
          if (result.isNotEmpty) return result;
        }
      }

      throw Exception('Invalid API response structure');
    } on TimeoutException catch (_) {
      throw Exception('The AI took too long to respond. Please check your internet connection and try again.');
    } catch (e) {
      print('API Call Error: $e');
      rethrow;
    }
  }
}
