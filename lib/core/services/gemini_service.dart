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
  // Removed unused fields
  // Helper to load and filter data from ai_suggestions.json by city (if possible)
  Future<Map<String, List<Map<String, dynamic>>>> _loadSuggestionsData() async {
    final dataString =
        await rootBundle.loadString('assets/data/ai_suggestions.json');
    final Map<String, dynamic> data = jsonDecode(dataString);
    return {
      'hotels': (data['hotels'] as List).cast<Map<String, dynamic>>(),
      'restaurants': (data['restaurants'] as List).cast<Map<String, dynamic>>(),
      'attractions': (data['attractions'] as List).cast<Map<String, dynamic>>()
    };
  }

  // Helper to filter by city name (case-insensitive, partial match)
  List<Map<String, dynamic>> _filterByCity(
      List<Map<String, dynamic>> items, String city) {
    if (city.trim().isEmpty) return items;
    final cityLower = city.toLowerCase();
    return items.where((item) {
      final name = (item['name'] ?? '').toString().toLowerCase();
      final location = (item['Location'] ?? '').toString().toLowerCase();
      return name.contains(cityLower) ||
          location.contains(cityLower) ||
          cityLower.contains(name) ||
          cityLower.contains(location);
    }).toList();
  }

  Future<String> getQuickRecommendations({
    required String destination,
    required String category, // 'hotels', 'restaurants', 'attractions'
    required double budget,
    required String currency,
  }) async {
    final suggestionsData = await _loadSuggestionsData();
    List<Map<String, dynamic>> hotels =
        _filterByCity(suggestionsData['hotels'] ?? [], destination);
    List<Map<String, dynamic>> restaurants =
        _filterByCity(suggestionsData['restaurants'] ?? [], destination);
    List<Map<String, dynamic>> attractions =
        _filterByCity(suggestionsData['attractions'] ?? [], destination);

    String hotelList = hotels.isNotEmpty
        ? hotels
            .take(3)
            .map((h) =>
                '${h['name']} (${h['Location'] ?? 'Location N/A'})\n  - approx. ${h['pricePerNight'] ?? 'N/A'} $currency/night')
            .join('\n')
        : 'Not found';

    String restaurantList = restaurants.isNotEmpty
        ? restaurants
            .take(3)
            .map((r) =>
                '${r['name']} (${r['Location'] ?? 'Location N/A'})\n  - avg. cost for two: ${r['averageCostForTwo'] ?? 'N/A'} $currency')
            .join('\n')
        : 'Not found';

    String attractionList = attractions.isNotEmpty
        ? attractions
            .take(3)
            .map((a) =>
                '${a['name']} (${a['Location'] ?? 'Location N/A'})\n  - entry fee: ${a['entryFee'] ?? 'N/A'} $currency')
            .join('\n')
        : 'Not found';

    String prompt = '''
      You are a Bangladesh travel expert. Use ONLY the following data for your recommendations. If any category is 'Not found', do not suggest anything for that category.

      Hotels:
      $hotelList

      Restaurants:
      $restaurantList

      Attractions:
      $attractionList

      Destination: $destination, Bangladesh
      Budget: $currency $budget

      Provide up to 3 options per category with:
      - Name and brief description
      - Approximate cost
      - Why it's recommended (if available)

      If 'Not found', say 'Not found'.
      Keep it brief and helpful. Use bullet points. No JSON.
      ''';

    try {
      final response = await _callGeminiAPI(prompt);
      return response;
    } on TimeoutException catch (_) {
      // Fallback: return local data if timeout
      return _localQuickRecommendationResponse(hotelList, restaurantList,
          attractionList, destination, currency, budget);
    } catch (e) {
      // Fallback for rate limit or other API errors
      if (e.toString().contains('429') || e.toString().contains('rate limit')) {
        return _localQuickRecommendationResponse(hotelList, restaurantList,
            attractionList, destination, currency, budget);
      }
      throw Exception('Failed to get quick recommendations: ${e.toString()}');
    }
  }

  String _localQuickRecommendationResponse(
    String hotelList,
    String restaurantList,
    String attractionList,
    String destination,
    String currency,
    double budget,
  ) {
    return '''Hotels:\n$hotelList\n\nRestaurants:\n$restaurantList\n\nAttractions:\n$attractionList\n\nDestination: $destination, Bangladesh\nBudget: $currency $budget\n''';
  }

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

    final suggestionsData = await _loadSuggestionsData();
    List<Map<String, dynamic>> hotels =
        _filterByCity(suggestionsData['hotels'] ?? [], destination);
    List<Map<String, dynamic>> restaurants =
        _filterByCity(suggestionsData['restaurants'] ?? [], destination);
    List<Map<String, dynamic>> attractions =
        _filterByCity(suggestionsData['attractions'] ?? [], destination);

    // Fix: If budget is too low or parsing fails, show top 3 hotels with a warning
    double nightlyBudget = 0;
    if (budget > 0 && days > 0) {
      nightlyBudget = budget / days;
    }
    List<Map<String, dynamic>> filteredHotels = hotels.where((h) {
      final price = h['pricePerNight'] ?? h['price_range'];
      if (price is num && price > 0 && nightlyBudget > 0) {
        return price <= nightlyBudget;
      }
      return true;
    }).toList();

    String hotelList;
    if (filteredHotels.isNotEmpty) {
      hotelList = filteredHotels
          .take(3)
          .map((h) =>
              '${h['name']} (${h['Location'] ?? 'Location N/A'})\n  - approx. ${h['pricePerNight'] ?? h['price_range'] ?? 'N/A'} $currency/night')
          .join('\n');
    } else if (hotels.isNotEmpty) {
      hotelList = hotels
          .take(3)
          .map((h) =>
              '${h['name']} (${h['Location'] ?? 'Location N/A'})\n  - approx. ${h['pricePerNight'] ?? h['price_range'] ?? 'N/A'} $currency/night (over budget)')
          .join('\n');
      hotelList = '[All available hotels exceed your budget]\n$hotelList';
    } else {
      hotelList = 'Not found';
    }

    String restaurantList = restaurants.isNotEmpty
        ? restaurants
            .take(3)
            .map((r) =>
                '${r['name']} (${r['Location'] ?? 'Location N/A'})\n  - avg. cost for two: ${r['averageCostForTwo'] ?? 'N/A'} $currency')
            .join('\n')
        : 'Not found';

    String attractionList = attractions.isNotEmpty
        ? attractions
            .take(3)
            .map((a) =>
                '${a['name']} (${a['Location'] ?? 'Location N/A'})\n  - entry fee: ${a['entryFee'] ?? 'N/A'} $currency')
            .join('\n')
        : 'Not found';

    String prompt = '''
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
      6. If budget is insufficient, clearly state:\n   - What can be done within budget\n   - How much additional budget is recommended for a complete experience

      Keep your response concise and practical. Use bullet points.
      Do NOT use JSON format - write in plain, readable English.
      ''';

    try {
      final response = await _callGeminiAPI(prompt);
      return response;
    } on TimeoutException catch (_) {
      // Fallback: return local data if timeout
      return _localTravelSuggestionResponse(
          hotelList,
          restaurantList,
          attractionList,
          destination,
          days,
          currency,
          budget,
          interestsText,
          styleText);
    } catch (e) {
      // Fallback for rate limit or other API errors
      if (e.toString().contains('429') || e.toString().contains('rate limit')) {
        return _localTravelSuggestionResponse(
            hotelList,
            restaurantList,
            attractionList,
            destination,
            days,
            currency,
            budget,
            interestsText,
            styleText);
      }
      throw Exception('Failed to get suggestions: ${e.toString()}');
    }
  }

  String _localTravelSuggestionResponse(
    String hotelList,
    String restaurantList,
    String attractionList,
    String destination,
    int days,
    String currency,
    double budget,
    String interestsText,
    String styleText,
  ) {
    return 'Hotels: $hotelList\nRestaurants: $restaurantList\nAttractions: $attractionList\n\nUSER REQUEST:\n- Destination: $destination, Bangladesh\n- Trip Duration: $days day(s)\n- Budget: $currency $budget\n- Interests: $interestsText\n- Travel Style: $styleText\n';
  }

  Future<String> _callGeminiAPI(String prompt) async {
    final apiKey = AppConstants.geminiApiKey;
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey');
    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode != 200) {
        throw Exception('API error ${response.statusCode}: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['candidates'] != null &&
          responseData['candidates'].isNotEmpty) {
        final candidate = responseData['candidates'][0];
        if (candidate['content'] != null &&
            candidate['content']['parts'] != null &&
            candidate['content']['parts'].isNotEmpty) {
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
      throw Exception(
          'The AI took too long to respond. Please check your internet connection and try again.');
    } catch (e) {
      throw Exception('API Call Error: $e');
    }
  }
}
