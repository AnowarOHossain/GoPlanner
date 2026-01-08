// Simplified Gemini API Service for free tier usage
// Returns plain English suggestions instead of complex JSON

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

/// Simplified service for AI travel suggestions
/// Optimized for Gemini free tier - uses plain text responses
class GeminiSimpleService {
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
    
    final prompt = '''
You are a helpful travel assistant for Bangladesh tourism. Give friendly travel suggestions in simple English.

USER REQUEST:
- Destination: $destination, Bangladesh
- Trip Duration: $days day(s)
- Budget: $currency $budget
- Interests: $interestsText
- Travel Style: $styleText

INSTRUCTIONS:
1. Suggest 2-3 hotels within budget (name, approx. price per night)
2. Suggest 3-4 restaurants (name, cuisine type, avg. cost for two)
3. Suggest 4-5 attractions/activities (name, entry fee if any)
4. Provide a simple day-wise outline
5. Calculate estimated total cost
6. If budget is insufficient, clearly state:
   - What can be done within budget
   - How much additional budget is recommended for a complete experience

Keep your response concise and practical. Use bullet points.
Do NOT use JSON format - write in plain, readable English.
''';

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
    final prompt = '''
You are a Bangladesh travel expert. Give quick $category recommendations.

Destination: $destination, Bangladesh
Budget: $currency $budget
Category: $category

Provide 5-6 $category options with:
- Name and brief description
- Approximate cost
- Why it's recommended

If budget is low, suggest budget-friendly options and mention premium alternatives with their costs.

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
      );

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
      
      // Extract text from response
      if (responseData['candidates'] != null &&
          responseData['candidates'].isNotEmpty) {
        final candidate = responseData['candidates'][0];
        if (candidate['content'] != null &&
            candidate['content']['parts'] != null &&
            candidate['content']['parts'].isNotEmpty) {
          return candidate['content']['parts'][0]['text'] ?? '';
        }
      }

      throw Exception('Invalid API response structure');
    } catch (e) {
      print('API Call Error: $e');
      rethrow;
    }
  }
}
