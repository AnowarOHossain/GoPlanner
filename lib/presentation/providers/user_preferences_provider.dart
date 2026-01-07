// Provider for managing user preferences with SharedPreferences persistence
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User preferences state model
class UserPreferencesState {
  final String budgetLevel; // budget, mid-range, luxury
  final String adventureLevel; // low, moderate, high
  final String travelPace; // relaxed, moderate, fast
  final String groupSize; // solo, couple, small-group, large-group
  final String preferredCurrency; // BDT, USD, EUR
  final String preferredLanguage; // en, bn
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool darkModeEnabled;
  final List<String> interests; // nature, history, food, adventure, culture

  const UserPreferencesState({
    this.budgetLevel = 'mid-range',
    this.adventureLevel = 'moderate',
    this.travelPace = 'relaxed',
    this.groupSize = 'small-group',
    this.preferredCurrency = 'BDT',
    this.preferredLanguage = 'en',
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.darkModeEnabled = false,
    this.interests = const ['nature', 'culture'],
  });

  UserPreferencesState copyWith({
    String? budgetLevel,
    String? adventureLevel,
    String? travelPace,
    String? groupSize,
    String? preferredCurrency,
    String? preferredLanguage,
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? darkModeEnabled,
    List<String>? interests,
  }) {
    return UserPreferencesState(
      budgetLevel: budgetLevel ?? this.budgetLevel,
      adventureLevel: adventureLevel ?? this.adventureLevel,
      travelPace: travelPace ?? this.travelPace,
      groupSize: groupSize ?? this.groupSize,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      interests: interests ?? this.interests,
    );
  }

  // Display text helpers
  String get budgetLevelDisplay {
    switch (budgetLevel) {
      case 'budget': return 'Budget';
      case 'mid-range': return 'Mid-range';
      case 'luxury': return 'Luxury';
      default: return 'Mid-range';
    }
  }

  String get adventureLevelDisplay {
    switch (adventureLevel) {
      case 'low': return 'Low';
      case 'moderate': return 'Moderate';
      case 'high': return 'High';
      default: return 'Moderate';
    }
  }

  String get travelPaceDisplay {
    switch (travelPace) {
      case 'relaxed': return 'Relaxed';
      case 'moderate': return 'Moderate';
      case 'fast': return 'Fast-paced';
      default: return 'Relaxed';
    }
  }

  String get groupSizeDisplay {
    switch (groupSize) {
      case 'solo': return 'Solo';
      case 'couple': return 'Couple';
      case 'small-group': return 'Small Group';
      case 'large-group': return 'Large Group';
      default: return 'Small Group';
    }
  }

  String get currencyDisplay {
    switch (preferredCurrency) {
      case 'BDT': return 'BDT (৳)';
      case 'USD': return 'USD (\$)';
      case 'EUR': return 'EUR (€)';
      default: return 'BDT (৳)';
    }
  }

  String get languageDisplay {
    switch (preferredLanguage) {
      case 'en': return 'English';
      case 'bn': return 'বাংলা (Bengali)';
      default: return 'English';
    }
  }
}

// Notifier class for managing preferences
class UserPreferencesNotifier extends StateNotifier<UserPreferencesState> {
  UserPreferencesNotifier() : super(const UserPreferencesState()) {
    _loadPreferences();
  }

  static const _keyBudgetLevel = 'pref_budget_level';
  static const _keyAdventureLevel = 'pref_adventure_level';
  static const _keyTravelPace = 'pref_travel_pace';
  static const _keyGroupSize = 'pref_group_size';
  static const _keyCurrency = 'pref_currency';
  static const _keyLanguage = 'pref_language';
  static const _keyNotifications = 'pref_notifications';
  static const _keyLocation = 'pref_location';
  static const _keyDarkMode = 'pref_dark_mode';
  static const _keyInterests = 'pref_interests';

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserPreferencesState(
      budgetLevel: prefs.getString(_keyBudgetLevel) ?? 'mid-range',
      adventureLevel: prefs.getString(_keyAdventureLevel) ?? 'moderate',
      travelPace: prefs.getString(_keyTravelPace) ?? 'relaxed',
      groupSize: prefs.getString(_keyGroupSize) ?? 'small-group',
      preferredCurrency: prefs.getString(_keyCurrency) ?? 'BDT',
      preferredLanguage: prefs.getString(_keyLanguage) ?? 'en',
      notificationsEnabled: prefs.getBool(_keyNotifications) ?? true,
      locationEnabled: prefs.getBool(_keyLocation) ?? true,
      darkModeEnabled: prefs.getBool(_keyDarkMode) ?? false,
      interests: prefs.getStringList(_keyInterests) ?? ['nature', 'culture'],
    );
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  Future<void> setBudgetLevel(String value) async {
    state = state.copyWith(budgetLevel: value);
    await _savePreference(_keyBudgetLevel, value);
  }

  Future<void> setAdventureLevel(String value) async {
    state = state.copyWith(adventureLevel: value);
    await _savePreference(_keyAdventureLevel, value);
  }

  Future<void> setTravelPace(String value) async {
    state = state.copyWith(travelPace: value);
    await _savePreference(_keyTravelPace, value);
  }

  Future<void> setGroupSize(String value) async {
    state = state.copyWith(groupSize: value);
    await _savePreference(_keyGroupSize, value);
  }

  Future<void> setCurrency(String value) async {
    state = state.copyWith(preferredCurrency: value);
    await _savePreference(_keyCurrency, value);
  }

  Future<void> setLanguage(String value) async {
    state = state.copyWith(preferredLanguage: value);
    await _savePreference(_keyLanguage, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _savePreference(_keyNotifications, value);
  }

  Future<void> setLocationEnabled(bool value) async {
    state = state.copyWith(locationEnabled: value);
    await _savePreference(_keyLocation, value);
  }

  Future<void> setDarkModeEnabled(bool value) async {
    state = state.copyWith(darkModeEnabled: value);
    await _savePreference(_keyDarkMode, value);
  }

  Future<void> setInterests(List<String> value) async {
    state = state.copyWith(interests: value);
    await _savePreference(_keyInterests, value);
  }

  Future<void> toggleInterest(String interest) async {
    final currentInterests = List<String>.from(state.interests);
    if (currentInterests.contains(interest)) {
      currentInterests.remove(interest);
    } else {
      currentInterests.add(interest);
    }
    await setInterests(currentInterests);
  }
}

// Main provider
final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferencesState>((ref) {
  return UserPreferencesNotifier();
});
