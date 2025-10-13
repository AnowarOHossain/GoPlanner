import 'package:equatable/equatable.dart';
import 'location_model.dart';

class AttractionModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final LocationModel location;
  final String division;
  final String district;
  final double rating;
  final int reviewCount;
  final double? entryFee;
  final String currency;
  final String category; // Historical, Natural, Cultural, Religious, Archaeological
  final String subcategory; // Mosque, Temple, Museum, Park, Beach, etc.
  final List<String> highlights;
  final String historicalPeriod; // Ancient, Medieval, Colonial, Modern
  final String openingHours;
  final String closingHours;
  final bool isOpen;
  final int estimatedDuration; // in minutes
  final String bestTimeToVisit; // Season or time
  final List<String> nearbyAttractions;
  final List<String> facilities;
  final List<String> activities;
  final bool isAccessible;
  final bool hasGuide;
  final bool hasParking;
  final bool hasRestaurant;
  final bool hasGiftShop;
  final String significance; // UNESCO, National Heritage, etc.
  final String? contactPhone;
  final String? website;

  const AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.location,
    required this.division,
    required this.district,
    required this.rating,
    required this.reviewCount,
    this.entryFee,
    required this.currency,
    required this.category,
    required this.subcategory,
    required this.highlights,
    required this.historicalPeriod,
    required this.openingHours,
    required this.closingHours,
    required this.isOpen,
    required this.estimatedDuration,
    required this.bestTimeToVisit,
    required this.nearbyAttractions,
    required this.facilities,
    required this.activities,
    required this.isAccessible,
    required this.hasGuide,
    required this.hasParking,
    required this.hasRestaurant,
    required this.hasGiftShop,
    required this.significance,
    this.contactPhone,
    this.website,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List),
      location: LocationModel.fromJson({
        ...json['location'] as Map<String, dynamic>,
        'country': (json['location'] as Map<String, dynamic>)['country'] ?? 'Bangladesh',
      }),
      division: json['division'] as String,
      district: json['district'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      entryFee: json['entryFee'] != null ? (json['entryFee'] as num).toDouble() : null,
      currency: json['currency'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      highlights: List<String>.from(json['highlights'] as List),
      historicalPeriod: json['historicalPeriod'] as String,
      openingHours: json['openingHours'] as String,
      closingHours: json['closingHours'] as String,
      isOpen: json['isOpen'] as bool,
      estimatedDuration: json['estimatedDuration'] as int,
      bestTimeToVisit: json['bestTimeToVisit'] as String,
      nearbyAttractions: List<String>.from(json['nearbyAttractions'] as List),
      facilities: List<String>.from(json['facilities'] as List),
      activities: List<String>.from(json['activities'] as List),
      isAccessible: json['isAccessible'] as bool,
      hasGuide: json['hasGuide'] as bool,
      hasParking: json['hasParking'] as bool,
      hasRestaurant: json['hasRestaurant'] as bool,
      hasGiftShop: json['hasGiftShop'] as bool,
      significance: json['significance'] as String,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'location': location.toJson(),
      'division': division,
      'district': district,
      'rating': rating,
      'reviewCount': reviewCount,
      'entryFee': entryFee,
      'currency': currency,
      'category': category,
      'subcategory': subcategory,
      'highlights': highlights,
      'historicalPeriod': historicalPeriod,
      'openingHours': openingHours,
      'closingHours': closingHours,
      'isOpen': isOpen,
      'estimatedDuration': estimatedDuration,
      'bestTimeToVisit': bestTimeToVisit,
      'nearbyAttractions': nearbyAttractions,
      'facilities': facilities,
      'activities': activities,
      'isAccessible': isAccessible,
      'hasGuide': hasGuide,
      'hasParking': hasParking,
      'hasRestaurant': hasRestaurant,
      'hasGiftShop': hasGiftShop,
      'significance': significance,
      'contactPhone': contactPhone,
      'website': website,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        location,
        division,
        district,
        rating,
        reviewCount,
        entryFee,
        currency,
        category,
        subcategory,
        highlights,
        historicalPeriod,
        openingHours,
        closingHours,
        isOpen,
        estimatedDuration,
        bestTimeToVisit,
        nearbyAttractions,
        facilities,
        activities,
        isAccessible,
        hasGuide,
        hasParking,
        hasRestaurant,
        hasGiftShop,
        significance,
        contactPhone,
        website,
      ];

  AttractionModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    LocationModel? location,
    String? division,
    String? district,
    double? rating,
    int? reviewCount,
    double? entryFee,
    String? currency,
    String? category,
    String? subcategory,
    List<String>? highlights,
    String? historicalPeriod,
    String? openingHours,
    String? closingHours,
    bool? isOpen,
    int? estimatedDuration,
    String? bestTimeToVisit,
    List<String>? nearbyAttractions,
    List<String>? facilities,
    List<String>? activities,
    bool? isAccessible,
    bool? hasGuide,
    bool? hasParking,
    bool? hasRestaurant,
    bool? hasGiftShop,
    String? significance,
    String? contactPhone,
    String? website,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      division: division ?? this.division,
      district: district ?? this.district,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      entryFee: entryFee ?? this.entryFee,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      highlights: highlights ?? this.highlights,
      historicalPeriod: historicalPeriod ?? this.historicalPeriod,
      openingHours: openingHours ?? this.openingHours,
      closingHours: closingHours ?? this.closingHours,
      isOpen: isOpen ?? this.isOpen,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      nearbyAttractions: nearbyAttractions ?? this.nearbyAttractions,
      facilities: facilities ?? this.facilities,
      activities: activities ?? this.activities,
      isAccessible: isAccessible ?? this.isAccessible,
      hasGuide: hasGuide ?? this.hasGuide,
      hasParking: hasParking ?? this.hasParking,
      hasRestaurant: hasRestaurant ?? this.hasRestaurant,
      hasGiftShop: hasGiftShop ?? this.hasGiftShop,
      significance: significance ?? this.significance,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
    );
  }

  // Helper getters
  bool get hasHighRating => rating >= 4.0;
  
  bool get isFree => entryFee == null || entryFee! <= 0;
  
  bool get isHistorical => category.toLowerCase().contains('historical') || 
                          category.toLowerCase().contains('archaeological');
  
  bool get isNatural => category.toLowerCase().contains('natural');
  
  bool get isReligious => category.toLowerCase().contains('religious');
  
  bool get isMuseum => subcategory.toLowerCase().contains('museum');
  
  bool get isPark => subcategory.toLowerCase().contains('park');
  
  bool get isMosque => subcategory.toLowerCase().contains('mosque');
  
  bool get isTemple => subcategory.toLowerCase().contains('temple');
  
  String get formattedEntryFee => 
      entryFee != null && entryFee! > 0 ? '$currency ${entryFee!.toStringAsFixed(0)}' : 'Free';
  
  String get formattedDuration {
    if (estimatedDuration < 60) {
      return '$estimatedDuration minutes';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      if (minutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minutes';
      }
    }
  }
  
  bool get isUNESCO => significance.toLowerCase().contains('unesco');
  
  bool get isNationalHeritage => significance.toLowerCase().contains('national heritage');
}