// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import attractions data source
import '../data/attractions_data.dart';
// Import attraction model
import '../data/models/attraction_model.dart';

// Provider that gives access to all Bangladesh attractions
final bangladeshAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  return bangladeshAttractions;
});

// Provider that filters attractions by division (e.g., Dhaka, Chittagong)
final attractionsByDivisionProvider = Provider.family<List<AttractionModel>, String?>((ref, division) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Return all attractions if no division selected
  if (division == null || division.isEmpty || division == 'All') {
    return attractions;
  }
  
  // Filter by matching division
  return attractions.where((attraction) => 
    attraction.division.toLowerCase() == division.toLowerCase()
  ).toList();
});

// Provider that filters attractions by category (e.g., Historical, Natural)
final attractionsByCategoryProvider = Provider.family<List<AttractionModel>, String?>((ref, category) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Return all attractions if no category selected
  if (category == null || category.isEmpty || category == 'All') {
    return attractions;
  }
  
  // Filter by matching category
  return attractions.where((attraction) => 
    attraction.category.toLowerCase() == category.toLowerCase()
  ).toList();
});

// Provider that filters attractions using multiple criteria at once
final filteredAttractionsProvider = Provider.family<List<AttractionModel>, AttractionFilters>((ref, filters) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Apply all filters to the list
  return attractions.where((attraction) {
    // Filter by division if specified
    if (filters.division != null && 
        filters.division!.isNotEmpty && 
        filters.division != 'All' &&
        attraction.division.toLowerCase() != filters.division!.toLowerCase()) {
      return false;
    }
    
    // Filter by category if specified
    if (filters.category != null && 
        filters.category!.isNotEmpty && 
        filters.category != 'All' &&
        attraction.category.toLowerCase() != filters.category!.toLowerCase()) {
      return false;
    }
    
    // Filter by subcategory if specified
    if (filters.subcategory != null && 
        filters.subcategory!.isNotEmpty && 
        filters.subcategory != 'All' &&
        attraction.subcategory.toLowerCase() != filters.subcategory!.toLowerCase()) {
      return false;
    }
    
    // Filter by minimum rating if specified
    if (filters.minRating != null && attraction.rating < filters.minRating!) {
      return false;
    }
    
    // Filter for free attractions only if requested
    if (filters.freeOnly && attraction.entryFee != null && attraction.entryFee! > 0) {
      return false;
    }
    
    // Filter for accessible attractions only if requested
    if (filters.accessibleOnly && !attraction.isAccessible) {
      return false;
    }
    
    // Filter by search text if provided
    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      final query = filters.searchQuery!.toLowerCase();
      // Search in name, description, highlights, and location
      return attraction.name.toLowerCase().contains(query) ||
             attraction.description.toLowerCase().contains(query) ||
             attraction.highlights.any((highlight) => highlight.toLowerCase().contains(query)) ||
             attraction.location.city.toLowerCase().contains(query) ||
             attraction.location.address.toLowerCase().contains(query);
    }
    
    return true;
  }).toList();
});

// Provider for searching attractions by text query
final attractionSearchProvider = Provider.family<List<AttractionModel>, String>((ref, query) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Return all if search is empty
  if (query.isEmpty) {
    return attractions;
  }
  
  // Search across multiple fields
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

// Provider for featured attractions (those with high ratings)
final featuredAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Get attractions with rating >= 4.5 and sort by rating
  return attractions.where((attraction) => attraction.rating >= 4.5).toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));
});

// Provider for UNESCO World Heritage sites in Bangladesh
final unescoAttractionsProvider = Provider<List<AttractionModel>>((ref) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Filter attractions with UNESCO in their significance
  return attractions.where((attraction) => 
    attraction.significance.toLowerCase().contains('unesco')
  ).toList();
});

// Provider that filters attractions by historical time period
final attractionsByPeriodProvider = Provider.family<List<AttractionModel>, String>((ref, period) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  
  // Filter by matching historical period
  return attractions.where((attraction) => 
    attraction.historicalPeriod.toLowerCase().contains(period.toLowerCase())
  ).toList();
});

// Provider for finding attractions near a given attraction
final nearbyAttractionsProvider = Provider.family<List<AttractionModel>, String>((ref, attractionId) {
  final attractions = ref.watch(bangladeshAttractionsProvider);
  final currentAttraction = attractions.firstWhere((a) => a.id == attractionId);
  
  // Find attractions in same division or district (excluding current)
  return attractions.where((attraction) => 
    attraction.id != attractionId &&
    (attraction.division == currentAttraction.division ||
     attraction.district == currentAttraction.district)
  ).take(5).toList();
});

// Filter options class for attraction filtering
class AttractionFilters {
  final String? division; // Filter by division
  final String? category; // Filter by category
  final String? subcategory; // Filter by subcategory
  final double? minRating; // Minimum rating filter
  final bool freeOnly; // Show only free attractions
  final bool accessibleOnly; // Show only accessible attractions
  final String? searchQuery; // Text search query

  const AttractionFilters({
    this.division,
    this.category,
    this.subcategory,
    this.minRating,
    this.freeOnly = false,
    this.accessibleOnly = false,
    this.searchQuery,
  });

  // Create a copy with modified filters
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

  // Reset all filters to default
  AttractionFilters clear() {
    return const AttractionFilters();
  }

  // Check if any filters are currently active
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

// List of all Bangladesh divisions for filtering
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

// List of attraction categories for filtering
const List<String> attractionCategories = [
  'All',
  'Historical',
  'Natural',
  'Religious',
  'Archaeological',
  'Cultural',
  'Modern',
];

// List of attraction subcategories for detailed filtering
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