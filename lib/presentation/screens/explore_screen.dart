// Import Flutter material design widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import providers for fetching data
import '../providers/listings_provider.dart';
// Import data models
import '../../data/models/hotel_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/attraction_model.dart';

// Explore screen - shows all hotels, restaurants, and attractions with search
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // Controller for search text input
  final TextEditingController _searchController = TextEditingController();
  // Store current search query
  String _searchQuery = '';
  // Store selected category filter (All, Hotels, Restaurants, Attractions)
  String _selectedCategory = 'All';

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers to get data from state management
    final hotelsAsync = ref.watch(bangladeshHotelsProvider);
    final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
    final attractionsAsync = ref.watch(bangladeshAttractionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E7D5A),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search hotels, restaurants, attractions...',
                hintStyle: const TextStyle(color: Colors.white70),
                // Search icon at the start
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                // Clear button appears when user types something
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          // Clear search text
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              // Update search query when user types
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Category Filter Chips Section
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Build filter chips for each category
                _buildCategoryChip('All', Icons.apps),
                _buildCategoryChip('Hotels', Icons.hotel),
                _buildCategoryChip('Restaurants', Icons.restaurant),
                _buildCategoryChip('Attractions', Icons.place),
              ],
            ),
          ),

          // Results List Section
          Expanded(
            child: hotelsAsync.when(
              // Show loading indicator while fetching hotels
              loading: () => const Center(child: CircularProgressIndicator()),
              // Show error message if hotels fail to load
              error: (error, stack) => Center(child: Text('Error: $error')),
              // When hotels are loaded successfully
              data: (hotels) {
                return restaurantsAsync.when(
                  // Show loading indicator while fetching restaurants
                  loading: () => const Center(child: CircularProgressIndicator()),
                  // Show error message if restaurants fail to load
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  // When restaurants are loaded successfully
                  data: (restaurants) {
                    return attractionsAsync.when(
                      // Show loading indicator while fetching attractions
                      loading: () => const Center(child: CircularProgressIndicator()),
                      // Show error message if attractions fail to load
                      error: (error, stack) => Center(child: Text('Error: $error')),
                      // When all data is loaded successfully
                      data: (attractions) {
                        // Filter results based on search query and selected category
                        final filteredResults = _getFilteredResults(
                          hotels,
                          restaurants,
                          attractions,
                        );

                        // Show message if no results found
                        if (filteredResults.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Build list of results
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredResults.length,
                          itemBuilder: (context, index) {
                            final item = filteredResults[index];
                            return _buildResultCard(item);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build category filter chip widget
  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF2E7D5A),
            ),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        // Update selected category when chip is tapped
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF2E7D5A),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Filter and combine all results based on search and category
  List<Map<String, dynamic>> _getFilteredResults(
    List<HotelModel> hotels,
    List<RestaurantModel> restaurants,
    List<AttractionModel> attractions,
  ) {
    List<Map<String, dynamic>> results = [];

    // Add hotels to results if category matches
    if (_selectedCategory == 'All' || _selectedCategory == 'Hotels') {
      for (var hotel in hotels) {
        // Check if hotel matches search query
        if (_searchQuery.isEmpty ||
            hotel.name.toLowerCase().contains(_searchQuery) ||
            hotel.location.city.toLowerCase().contains(_searchQuery) ||
            hotel.division.toLowerCase().contains(_searchQuery)) {
          results.add({
            'type': 'hotel',
            'data': hotel,
          });
        }
      }
    }

    // Add restaurants to results if category matches
    if (_selectedCategory == 'All' || _selectedCategory == 'Restaurants') {
      for (var restaurant in restaurants) {
        // Check if restaurant matches search query
        if (_searchQuery.isEmpty ||
            restaurant.name.toLowerCase().contains(_searchQuery) ||
            restaurant.location.city.toLowerCase().contains(_searchQuery) ||
            restaurant.division.toLowerCase().contains(_searchQuery) ||
            restaurant.cuisineType.toLowerCase().contains(_searchQuery)) {
          results.add({
            'type': 'restaurant',
            'data': restaurant,
          });
        }
      }
    }

    // Add attractions to results if category matches
    if (_selectedCategory == 'All' || _selectedCategory == 'Attractions') {
      for (var attraction in attractions) {
        // Check if attraction matches search query
        if (_searchQuery.isEmpty ||
            attraction.name.toLowerCase().contains(_searchQuery) ||
            attraction.location.city.toLowerCase().contains(_searchQuery) ||
            attraction.division.toLowerCase().contains(_searchQuery) ||
            attraction.category.toLowerCase().contains(_searchQuery)) {
          results.add({
            'type': 'attraction',
            'data': attraction,
          });
        }
      }
    }

    return results;
  }

  // Build card widget for each search result
  Widget _buildResultCard(Map<String, dynamic> item) {
    final type = item['type'] as String;
    final data = item['data'];

    // Variables to store card information
    String name = '';
    String location = '';
    String subtitle = '';
    String price = '';
    double rating = 0.0;
    IconData icon = Icons.place;
    Color color = Colors.green;
    String route = '';

    // Extract data based on item type
    switch (type) {
      case 'hotel':
        // Get hotel data
        final hotel = data as HotelModel;
        name = hotel.name;
        location = '${hotel.location.city}, ${hotel.division}';
        subtitle = hotel.hotelType;
        price = '৳${hotel.pricePerNight.toInt()}/night';
        rating = hotel.rating;
        icon = Icons.hotel;
        color = Colors.blue;
        route = '/hotel/${hotel.id}';
        break;
      case 'restaurant':
        // Get restaurant data
        final restaurant = data as RestaurantModel;
        name = restaurant.name;
        location = '${restaurant.location.city}, ${restaurant.division}';
        subtitle = restaurant.cuisineType;
        price = restaurant.priceRange;
        rating = restaurant.rating;
        icon = Icons.restaurant;
        color = Colors.orange;
        route = '/restaurant/${restaurant.id}';
        break;
      case 'attraction':
        // Get attraction data
        final attraction = data as AttractionModel;
        name = attraction.name;
        location = '${attraction.location.city}, ${attraction.division}';
        subtitle = attraction.category;
        price = attraction.entryFee != null ? '৳${attraction.entryFee!.toInt()}' : 'Free';
        rating = attraction.rating;
        icon = Icons.place;
        color = Colors.green;
        route = '/attraction/${attraction.id}';
        break;
    }

    // Build card UI
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // Navigate to detail page when tapped
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              
              // Details Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name text
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subtitle (hotel type, cuisine, or category)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Location row
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Rating and Price Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Star rating display
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price display
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
