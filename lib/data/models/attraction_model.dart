import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location_model.dart';

part 'attraction_model.g.dart';

@JsonSerializable()
class AttractionModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final LocationModel location;
  final double rating;
  final int reviewCount;
  final double? entryFee;
  final String currency;
  final String category; // museum, park, monument, entertainment, etc.
  final String openingHours;
  final int estimatedDuration; // in minutes
  final List<String> activities;
  final bool isAccessible;
  final bool isFree;
  final String? contactPhone;
  final String? website;
  final List<String>? bestTimeToVisit; // seasons or times
  final Map<String, dynamic>? additionalInfo;

  const AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.currency,
    required this.category,
    required this.openingHours,
    required this.estimatedDuration,
    required this.activities,
    this.entryFee,
    this.isAccessible = true,
    this.isFree = false,
    this.contactPhone,
    this.website,
    this.bestTimeToVisit,
    this.additionalInfo,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) =>
      _$AttractionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttractionModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        location,
        rating,
        reviewCount,
        entryFee,
        currency,
        category,
        openingHours,
        estimatedDuration,
        activities,
        isAccessible,
        isFree,
        contactPhone,
        website,
        bestTimeToVisit,
        additionalInfo,
      ];

  AttractionModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    LocationModel? location,
    double? rating,
    int? reviewCount,
    double? entryFee,
    String? currency,
    String? category,
    String? openingHours,
    int? estimatedDuration,
    List<String>? activities,
    bool? isAccessible,
    bool? isFree,
    String? contactPhone,
    String? website,
    List<String>? bestTimeToVisit,
    Map<String, dynamic>? additionalInfo,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      entryFee: entryFee ?? this.entryFee,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      openingHours: openingHours ?? this.openingHours,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      activities: activities ?? this.activities,
      isAccessible: isAccessible ?? this.isAccessible,
      isFree: isFree ?? this.isFree,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get hasHighRating => rating >= 4.0;
  
  bool get isMuseum => category.toLowerCase() == 'museum';
  
  bool get isPark => category.toLowerCase() == 'park';
  
  bool get isMonument => category.toLowerCase() == 'monument';
  
  String get formattedDuration {
    if (estimatedDuration < 60) {
      return '${estimatedDuration}min';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
    }
  }
  
  String get formattedEntryFee {
    if (isFree || entryFee == null || entryFee == 0) {
      return 'Free';
    }
    return '$currency ${entryFee!.toStringAsFixed(2)}';
  }
  
  double get actualEntryFee => isFree ? 0.0 : (entryFee ?? 0.0);
}