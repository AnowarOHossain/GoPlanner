// AI suggestions provider
// Uses plain text responses for better free tier compatibility

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/gemini_service.dart';

// Provider for the simplified Gemini service
final geminiSimpleServiceProvider = Provider<GeminiSimpleService>((ref) {
  return GeminiSimpleService();
});

// State class for AI suggestions
class AISuggestionsState {
  final bool isLoading;
  final String? suggestions;
  final String? error;
  final String? destination;
  final double? budget;
  final int? days;

  AISuggestionsState({
    this.isLoading = false,
    this.suggestions,
    this.error,
    this.destination,
    this.budget,
    this.days,
  });

  AISuggestionsState copyWith({
    bool? isLoading,
    String? suggestions,
    String? error,
    String? destination,
    double? budget,
    int? days,
  }) {
    return AISuggestionsState(
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
      error: error,
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      days: days ?? this.days,
    );
  }
}

// Notifier for AI suggestions
class AISuggestionsNotifier extends StateNotifier<AISuggestionsState> {
  final GeminiSimpleService _geminiService;

  AISuggestionsNotifier(this._geminiService) : super(AISuggestionsState());

  /// Generate travel suggestions in plain English
  Future<void> generateSuggestions({
    required String destination,
    required int days,
    required double budget,
    String currency = 'BDT',
    List<String>? interests,
    String? travelStyle,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      destination: destination,
      budget: budget,
      days: days,
    );

    try {
      final suggestions = await _geminiService.getTravelSuggestions(
        destination: destination,
        days: days,
        budget: budget,
        currency: currency,
        interests: interests,
        travelStyle: travelStyle,
      );

      state = state.copyWith(
        isLoading: false,
        suggestions: suggestions,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get quick recommendations for a category
  Future<void> getQuickRecommendations({
    required String destination,
    required String category,
    required double budget,
    String currency = 'BDT',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final suggestions = await _geminiService.getQuickRecommendations(
        destination: destination,
        category: category,
        budget: budget,
        currency: currency,
      );

      state = state.copyWith(
        isLoading: false,
        suggestions: suggestions,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear suggestions
  void clear() {
    state = AISuggestionsState();
  }
}

// Provider for AI suggestions
final aiSuggestionsProvider =
    StateNotifierProvider<AISuggestionsNotifier, AISuggestionsState>((ref) {
  final service = ref.watch(geminiSimpleServiceProvider);
  return AISuggestionsNotifier(service);
});
