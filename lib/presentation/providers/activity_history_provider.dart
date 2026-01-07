// Provider for tracking user activity history
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Activity types
enum ActivityType {
  viewedHotel,
  viewedRestaurant,
  viewedAttraction,
  addedToFavorites,
  removedFromFavorites,
  addedToBudget,
  removedFromBudget,
  searchedFor,
  filteredResults,
  viewedMap,
  sharedItem,
}

// Single activity item
class UserActivity {
  final String id;
  final ActivityType type;
  final String itemId;
  final String itemName;
  final String itemType; // hotel, restaurant, attraction
  final DateTime timestamp;
  final String? details;

  UserActivity({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.timestamp,
    this.details,
  });

  String get typeDisplay {
    switch (type) {
      case ActivityType.viewedHotel:
      case ActivityType.viewedRestaurant:
      case ActivityType.viewedAttraction:
        return 'Viewed details';
      case ActivityType.addedToFavorites:
        return 'Added to favorites';
      case ActivityType.removedFromFavorites:
        return 'Removed from favorites';
      case ActivityType.addedToBudget:
        return 'Added to budget';
      case ActivityType.removedFromBudget:
        return 'Removed from budget';
      case ActivityType.searchedFor:
        return 'Searched for';
      case ActivityType.filteredResults:
        return 'Filtered results';
      case ActivityType.viewedMap:
        return 'Viewed on map';
      case ActivityType.sharedItem:
        return 'Shared';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'itemId': itemId,
        'itemName': itemName,
        'itemType': itemType,
        'timestamp': timestamp.toIso8601String(),
        'details': details,
      };

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
        id: json['id'] as String,
        type: ActivityType.values[json['type'] as int],
        itemId: json['itemId'] as String,
        itemName: json['itemName'] as String,
        itemType: json['itemType'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        details: json['details'] as String?,
      );
}

// Travel history summary
class TravelHistorySummary {
  final int totalPlacesViewed;
  final int totalFavoritesAdded;
  final int totalBudgetItems;
  final Map<String, int> viewsByCategory; // hotel, restaurant, attraction
  final List<String> recentSearches;
  final DateTime? firstActivity;
  final DateTime? lastActivity;

  const TravelHistorySummary({
    this.totalPlacesViewed = 0,
    this.totalFavoritesAdded = 0,
    this.totalBudgetItems = 0,
    this.viewsByCategory = const {},
    this.recentSearches = const [],
    this.firstActivity,
    this.lastActivity,
  });
}

// Notifier for managing activity history
class ActivityHistoryNotifier extends StateNotifier<List<UserActivity>> {
  ActivityHistoryNotifier() : super([]) {
    _loadActivities();
  }

  static const _storageKey = 'user_activity_history';
  static const int _maxActivities = 100; // Keep last 100 activities

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        state = jsonList.map((j) => UserActivity.fromJson(j)).toList();
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.map((a) => a.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addActivity({
    required ActivityType type,
    required String itemId,
    required String itemName,
    required String itemType,
    String? details,
  }) async {
    final activity = UserActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      itemId: itemId,
      itemName: itemName,
      itemType: itemType,
      timestamp: DateTime.now(),
      details: details,
    );

    // Add to beginning of list and keep only max activities
    state = [activity, ...state].take(_maxActivities).toList();
    await _saveActivities();
  }

  Future<void> clearHistory() async {
    state = [];
    await _saveActivities();
  }

  TravelHistorySummary getSummary() {
    if (state.isEmpty) {
      return const TravelHistorySummary();
    }

    final viewTypes = [
      ActivityType.viewedHotel,
      ActivityType.viewedRestaurant,
      ActivityType.viewedAttraction,
    ];

    final views = state.where((a) => viewTypes.contains(a.type)).toList();
    final favorites = state.where((a) => a.type == ActivityType.addedToFavorites).toList();
    final budgetItems = state.where((a) => a.type == ActivityType.addedToBudget).toList();
    final searches = state
        .where((a) => a.type == ActivityType.searchedFor)
        .map((a) => a.details ?? a.itemName)
        .toSet()
        .take(10)
        .toList();

    final viewsByCategory = <String, int>{};
    for (final view in views) {
      viewsByCategory[view.itemType] = (viewsByCategory[view.itemType] ?? 0) + 1;
    }

    return TravelHistorySummary(
      totalPlacesViewed: views.length,
      totalFavoritesAdded: favorites.length,
      totalBudgetItems: budgetItems.length,
      viewsByCategory: viewsByCategory,
      recentSearches: searches,
      firstActivity: state.isNotEmpty ? state.last.timestamp : null,
      lastActivity: state.isNotEmpty ? state.first.timestamp : null,
    );
  }

  List<UserActivity> getRecentActivities({int limit = 10}) {
    return state.take(limit).toList();
  }

  List<UserActivity> getActivitiesByType(ActivityType type) {
    return state.where((a) => a.type == type).toList();
  }

  List<UserActivity> getActivitiesForItem(String itemId) {
    return state.where((a) => a.itemId == itemId).toList();
  }
}

// Main provider
final activityHistoryProvider =
    StateNotifierProvider<ActivityHistoryNotifier, List<UserActivity>>((ref) {
  return ActivityHistoryNotifier();
});

// Derived providers
final travelHistorySummaryProvider = Provider<TravelHistorySummary>((ref) {
  ref.watch(activityHistoryProvider);
  return ref.read(activityHistoryProvider.notifier).getSummary();
});

final recentActivitiesProvider = Provider<List<UserActivity>>((ref) {
  ref.watch(activityHistoryProvider);
  return ref.read(activityHistoryProvider.notifier).getRecentActivities();
});
