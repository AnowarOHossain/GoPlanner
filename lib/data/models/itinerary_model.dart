// Import Equatable to compare objects easily
import 'package:equatable/equatable.dart';
// Import cart item and location models
import 'cart_item_model.dart';
import 'location_model.dart';

// Itinerary model - represents a complete travel plan
// This is for future Gemini API integration to generate travel plans

// Main itinerary class - full travel plan
class ItineraryModel extends Equatable {
  final String id; // Unique identifier
  final String title; // Trip name (e.g., "Weekend in Dhaka")
  final String description; // Trip description
  final LocationModel destination; // Where the trip is
  final DateTime startDate; // Trip start date
  final DateTime endDate; // Trip end date
  final double totalBudget; // Total budget for trip
  final String currency; // Currency (e.g., BDT)
  final List<DayPlanModel> dayPlans; // Plan for each day
  final List<String> tags; // Tags (e.g., "family", "adventure")
  final DateTime createdAt; // When itinerary was created
  final DateTime updatedAt; // When itinerary was last updated

  const ItineraryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    required this.currency,
    required this.dayPlans,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create itinerary from JSON data
  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      destination: LocationModel.fromJson(json['destination'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalBudget: (json['totalBudget'] as num).toDouble(),
      currency: json['currency'] as String,
      dayPlans: (json['dayPlans'] as List).map((e) => DayPlanModel.fromJson(e as Map<String, dynamic>)).toList(),
      tags: List<String>.from(json['tags'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert itinerary to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'destination': destination.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalBudget': totalBudget,
      'currency': currency,
      'dayPlans': dayPlans.map((e) => e.toJson()).toList(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        destination,
        startDate,
        endDate,
        totalBudget,
        currency,
        dayPlans,
        tags,
        createdAt,
        updatedAt,
      ];

  ItineraryModel copyWith({
    String? id,
    String? title,
    String? description,
    LocationModel? destination,
    DateTime? startDate,
    DateTime? endDate,
    double? totalBudget,
    String? currency,
    List<DayPlanModel>? dayPlans,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItineraryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalBudget: totalBudget ?? this.totalBudget,
      currency: currency ?? this.currency,
      dayPlans: dayPlans ?? this.dayPlans,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get totalDays => endDate.difference(startDate).inDays + 1;
  
  bool get isMultiDay => totalDays > 1;
  
  bool get isActive => DateTime.now().isBefore(endDate);
}

class DayPlanModel extends Equatable {
  final String id;
  final int dayNumber;
  final DateTime date;
  final List<ItineraryItemModel> items;
  final String? notes;
  final double dailyBudget;

  const DayPlanModel({
    required this.id,
    required this.dayNumber,
    required this.date,
    required this.items,
    this.notes,
    required this.dailyBudget,
  });

  factory DayPlanModel.fromJson(Map<String, dynamic> json) {
    return DayPlanModel(
      id: json['id'] as String,
      dayNumber: json['dayNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List).map((e) => ItineraryItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      notes: json['notes'] as String?,
      dailyBudget: (json['dailyBudget'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'date': date.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'notes': notes,
      'dailyBudget': dailyBudget,
    };
  }

  @override
  List<Object?> get props => [id, dayNumber, date, items, notes, dailyBudget];

  DayPlanModel copyWith({
    String? id,
    int? dayNumber,
    DateTime? date,
    List<ItineraryItemModel>? items,
    String? notes,
    double? dailyBudget,
  }) {
    return DayPlanModel(
      id: id ?? this.id,
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      dailyBudget: dailyBudget ?? this.dailyBudget,
    );
  }

  double get totalSpent => items.fold(0.0, (sum, item) => sum + item.estimatedCost);
}

class ItineraryItemModel extends Equatable {
  final String id;
  final String itemId;
  final ItemType type;
  final String name;
  final LocationModel location;
  final DateTime startTime;
  final DateTime endTime;
  final double estimatedCost;
  final String currency;
  final String? notes;
  final bool isBooked;

  const ItineraryItemModel({
    required this.id,
    required this.itemId,
    required this.type,
    required this.name,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.estimatedCost,
    required this.currency,
    this.notes,
    this.isBooked = false,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      type: ItemType.values.firstWhere((e) => e.name == json['type'] as String),
      name: json['name'] as String,
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      currency: json['currency'] as String,
      notes: json['notes'] as String?,
      isBooked: json['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'type': type.name,
      'name': name,
      'location': location.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'estimatedCost': estimatedCost,
      'currency': currency,
      'notes': notes,
      'isBooked': isBooked,
    };
  }

  @override
  List<Object?> get props => [
        id,
        itemId,
        type,
        name,
        location,
        startTime,
        endTime,
        estimatedCost,
        currency,
        notes,
        isBooked,
      ];

  ItineraryItemModel copyWith({
    String? id,
    String? itemId,
    ItemType? type,
    String? name,
    LocationModel? location,
    DateTime? startTime,
    DateTime? endTime,
    double? estimatedCost,
    String? currency,
    String? notes,
    bool? isBooked,
  }) {
    return ItineraryItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      name: name ?? this.name,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  Duration get duration => endTime.difference(startTime);
  
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours == 0) return '${minutes}min';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}min';
  }
}