import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';
import 'location_model.dart';

part 'itinerary_model.g.dart';

@JsonSerializable()
class ItineraryModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final LocationModel destination;
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final String currency;
  final List<DayPlanModel> dayPlans;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAiGenerated;
  final String? userId;
  final Map<String, dynamic>? preferences;

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
    this.isAiGenerated = false,
    this.userId,
    this.preferences,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) =>
      _$ItineraryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryModelToJson(this);

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
        isAiGenerated,
        userId,
        preferences,
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
    bool? isAiGenerated,
    String? userId,
    Map<String, dynamic>? preferences,
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
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
      userId: userId ?? this.userId,
      preferences: preferences ?? this.preferences,
    );
  }

  int get numberOfDays => endDate.difference(startDate).inDays + 1;

  double get calculatedTotalCost {
    return dayPlans.fold(0.0, (total, day) => total + day.totalCost);
  }

  String get formattedTotalBudget {
    return '$currency ${totalBudget.toStringAsFixed(2)}';
  }

  String get formattedCalculatedCost {
    return '$currency ${calculatedTotalCost.toStringAsFixed(2)}';
  }

  bool get isWithinBudget => calculatedTotalCost <= totalBudget;

  double get budgetRemaining => totalBudget - calculatedTotalCost;

  String get formattedBudgetRemaining {
    final remaining = budgetRemaining;
    final sign = remaining >= 0 ? '+' : '-';
    return '$sign$currency ${remaining.abs().toStringAsFixed(2)}';
  }
}

@JsonSerializable()
class DayPlanModel extends Equatable {
  final int dayNumber;
  final DateTime date;
  final List<ItineraryItemModel> activities;
  final String? notes;

  const DayPlanModel({
    required this.dayNumber,
    required this.date,
    required this.activities,
    this.notes,
  });

  factory DayPlanModel.fromJson(Map<String, dynamic> json) =>
      _$DayPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayPlanModelToJson(this);

  @override
  List<Object?> get props => [dayNumber, date, activities, notes];

  DayPlanModel copyWith({
    int? dayNumber,
    DateTime? date,
    List<ItineraryItemModel>? activities,
    String? notes,
  }) {
    return DayPlanModel(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      activities: activities ?? this.activities,
      notes: notes ?? this.notes,
    );
  }

  double get totalCost {
    return activities.fold(0.0, (total, activity) => total + activity.cost);
  }

  String formattedTotalCost(String currency) {
    return '$currency ${totalCost.toStringAsFixed(2)}';
  }
}

@JsonSerializable()
class ItineraryItemModel extends Equatable {
  final String id;
  final String name;
  final ItemType type;
  final String startTime;
  final String? endTime;
  final double cost;
  final LocationModel? location;
  final String? description;
  final String? imageUrl;
  final int? duration; // in minutes
  final bool isBooked;

  const ItineraryItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.startTime,
    required this.cost,
    this.endTime,
    this.location,
    this.description,
    this.imageUrl,
    this.duration,
    this.isBooked = false,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItineraryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryItemModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        startTime,
        endTime,
        cost,
        location,
        description,
        imageUrl,
        duration,
        isBooked,
      ];

  ItineraryItemModel copyWith({
    String? id,
    String? name,
    ItemType? type,
    String? startTime,
    String? endTime,
    double? cost,
    LocationModel? location,
    String? description,
    String? imageUrl,
    int? duration,
    bool? isBooked,
  }) {
    return ItineraryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      cost: cost ?? this.cost,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}