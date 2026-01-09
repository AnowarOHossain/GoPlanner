import 'dart:convert';
import 'package:flutter/services.dart';

class TripSuggestionService {
  static Future<String> getTripPlan({
    required String city,
    required double budget,
  }) async {
    final String jsonString = await rootBundle.loadString('assets/data/ai_suggestions.json');
    final Map<String, dynamic> data = json.decode(jsonString);


    String cityLower = city.toLowerCase();
    final hotels = (data['hotels'] as List)
      .where((hotel) => hotel['name'].toString().toLowerCase().contains(cityLower) || cityLower.contains(hotel['name'].toString().toLowerCase()))
      .where((hotel) => hotel['pricePerNight'] <= budget)
      .toList();

    final restaurants = (data['restaurants'] as List)
      .where((restaurant) => restaurant['name'].toString().toLowerCase().contains(cityLower) || cityLower.contains(restaurant['name'].toString().toLowerCase()))
      .toList();

    final attractions = (data['attractions'] as List)
      .where((attraction) => attraction['name'].toString().toLowerCase().contains(cityLower) || cityLower.contains(attraction['name'].toString().toLowerCase()))
      .toList();

    // Try Gemini API first, fallback to local if error
    try {
      // You can add Gemini API call here if needed
      throw Exception('Simulated Gemini API error for fallback');
    } catch (e) {
        String response = 'Here are some suggestions for your trip to $city, Bangladesh, based only on the provided data:\n';
        response += '\n* **Hotels:**\n';
        if (hotels.isNotEmpty) {
          for (var h in hotels.take(3)) {
            response += '    * ${h['name']} (approx. ${h['pricePerNight']} BDT/night)\n';
          }
        } else {
          response += '    * Not found\n';
        }

        response += '\n* **Restaurants:**\n';
        if (restaurants.isNotEmpty) {
          for (var r in restaurants.take(3)) {
            response += '    * ${r['name']} (avg. for two: ${r['averageCostForTwo']} BDT)\n';
          }
        } else {
          response += '    * Not found\n';
        }

        response += '\n* **Attractions:**\n';
        if (attractions.isNotEmpty) {
          for (var a in attractions.take(3)) {
            response += '    * ${a['name']} (entry fee: ${a['entryFee']})\n';
          }
        } else {
          response += '    * Not found\n';
        }

        // Ensure all categories are always present, even if empty
        return response.trim();
    }
  }
}
