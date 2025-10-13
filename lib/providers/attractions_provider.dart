import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/attractions_data.dart';
import '../data/models/attraction_model.dart';

// Provider for all Bangladesh attractions
final bangladeshAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  return bangladeshAttractions;
});

// Provider for filtered attractions by division
final attractionsByDivisionProvider = Provider.family<List<AttractionModel>, String?>((ref, division) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  if (division == null || division.isEmpty || division == 'All') {
    return attractions;
  }
  
  return attractions.where((attraction) => 
    attraction.division.toLowerCase() == division.toLowerCase()
  ).toList();
});

// Provider for filtered attractions by category
final attractionsByCategoryProvider = Provider.family<List<AttractionModel>, String?>((ref, category) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  if (category == null || category.isEmpty || category == 'All') {
    return attractions;
  }
  
  return attractions.where((attraction) => 
    attraction.category.toLowerCase() == category.toLowerCase()
  ).toList();
});

// Provider for attractions with multiple filters
final filteredAttractionsProvider = Provider.family<List<AttractionModel>, AttractionFilters>((ref, filters) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  return attractions.where((attraction) {
    // Division filter
    if (filters.division != null && 
        filters.division!.isNotEmpty && 
        filters.division != 'All' &&
        attraction.division.toLowerCase() != filters.division!.toLowerCase()) {
      return false;
    }
    
    // Category filter
    if (filters.category != null && 
        filters.category!.isNotEmpty && 
        filters.category != 'All' &&
        attraction.category.toLowerCase() != filters.category!.toLowerCase()) {
      return false;
    }
    
    // Subcategory filter
    if (filters.subcategory != null && 
        filters.subcategory!.isNotEmpty && 
        filters.subcategory != 'All' &&
        attraction.subcategory.toLowerCase() != filters.subcategory!.toLowerCase()) {
      return false;
    }
    
    // Rating filter
    if (filters.minRating != null && attraction.rating < filters.minRating!) {
      return false;
    }
    
    // Entry fee filter
    if (filters.freeOnly && attraction.entryFee != null && attraction.entryFee! > 0) {
      return false;
    }
    
    // Accessibility filter
    if (filters.accessibleOnly && !attraction.isAccessible) {
      return false;
    }
    
    // Search query filter
    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      final query = filters.searchQuery!.toLowerCase();
      return attraction.name.toLowerCase().contains(query) ||
             attraction.description.toLowerCase().contains(query) ||
             attraction.highlights.any((highlight) => highlight.toLowerCase().contains(query)) ||
             attraction.location.city.toLowerCase().contains(query) ||
             attraction.location.address.toLowerCase().contains(query);
    }
    
    return true;
  }).toList();
});

// Provider for search results
final attractionSearchProvider = Provider.family<List<AttractionModel>, String>((ref, query) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  if (query.isEmpty) {
    return attractions;
  }
  
  final searchQuery = query.toLowerCase();
  return attractions.where((attraction) {
    return attraction.name.toLowerCase().contains(searchQuery) ||
           attraction.description.toLowerCase().contains(searchQuery) ||
           attraction.highlights.any((highlight) => highlight.toLowerCase().contains(searchQuery)) ||
           attraction.location.city.toLowerCase().contains(searchQuery) ||
           attraction.category.toLowerCase().contains(searchQuery) ||
           attraction.subcategory.toLowerCase().contains(searchQuery);
  }).toList();
});

// Provider for featured attractions (highly rated)
final featuredAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  return attractions.where((attraction) => attraction.rating >= 4.5).toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));
});

// Provider for UNESCO World Heritage sites
final unescoAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  return attractions.where((attraction) => 
    attraction.significance.toLowerCase().contains('unesco')
  ).toList();
});

// Provider for attractions by historical period
final attractionsByPeriodProvider = Provider.family<List<AttractionModel>, String>((ref, period) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  return attractions.where((attraction) => 
    attraction.historicalPeriod.toLowerCase().contains(period.toLowerCase())
  ).toList();
});

// Provider for nearby attractions
final nearbyAttractionsProvider = Provider.family<List<AttractionModel>, String>((ref, attractionId) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  final currentAttraction = attractions.firstWhere((a) => a.id == attractionId);
  
  // Find attractions in the same division or district
  return attractions.where((attraction) => 
    attraction.id != attractionId &&
    (attraction.division == currentAttraction.division ||
     attraction.district == currentAttraction.district)
  ).take(5).toList();
});

// Data class for attraction filters
class AttractionFilters {
  final String? division;
  final String? category;
  final String? subcategory;
  final double? minRating;
  final bool freeOnly;
  final bool accessibleOnly;
  final String? searchQuery;

  const AttractionFilters({
    this.division,
    this.category,
    this.subcategory,
    this.minRating,
    this.freeOnly = false,
    this.accessibleOnly = false,
    this.searchQuery,
  });

  AttractionFilters copyWith({
    String? division,
    String? category,
    String? subcategory,
    double? minRating,
    bool? freeOnly,
    bool? accessibleOnly,
    String? searchQuery,
  }) {
    return AttractionFilters(
      division: division ?? this.division,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      minRating: minRating ?? this.minRating,
      freeOnly: freeOnly ?? this.freeOnly,
      accessibleOnly: accessibleOnly ?? this.accessibleOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Reset all filters
  AttractionFilters clear() {
    return const AttractionFilters();
  }

  // Check if any filters are active
  bool get hasActiveFilters {
    return division != null && division != 'All' ||
           category != null && category != 'All' ||
           subcategory != null && subcategory != 'All' ||
           minRating != null ||
           freeOnly ||
           accessibleOnly ||
           searchQuery != null && searchQuery!.isNotEmpty;
  }
}

// Lists for filter options
const List<String> bangladeshDivisions = [
  'All',
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Khulna',
  'Sylhet',
  'Rangpur',
  'Barisal',
  'Mymensingh',
];

const List<String> attractionCategories = [
  'All',
  'Historical',
  'Natural',
  'Religious',
  'Archaeological',
  'Cultural',
  'Modern',
];

const List<String> attractionSubcategories = [
  'All',
  'National Park',
  'Islamic Heritage',
  'Buddhist Heritage',
  'Mughal Fort',
  'Beach',
  'War Memorial',
  'Palace Museum',
  'Historic Mosque',
  'Swamp Forest',
  'Hill Station',
  'Tea Estate',
  'Lake',
  'Hindu Temple',
  'Coral Island',
];