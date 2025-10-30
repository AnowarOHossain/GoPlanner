// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import Geolocator for GPS location
import 'package:geolocator/geolocator.dart' as geo;
// Import listings provider for hotels, restaurants, attractions
import '../providers/listings_provider.dart';
// Import Google Map widget
import '../widgets/google_map_widget.dart';

// Maps screen showing locations of hotels, restaurants, and attractions
// Has 3 tabs: Hotels, Restaurants, and Attractions
// Shows items on Google Map with user's current location
class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controls tab switching
  String _selectedCategory = 'All'; // Currently selected category filter
  bool _isLocationEnabled = false; // GPS location permission status
  geo.Position? _currentPosition; // User's current GPS position

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocationEnabled = false;
        });
        return;
      }

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }

      if (permission == geo.LocationPermission.whileInUse ||
          permission == geo.LocationPermission.always) {
        _getCurrentLocation();
      }
    } catch (e) {
      print('Error checking location permission: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _isLocationEnabled = true;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps & Navigation'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Get Current Location',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.map, size: 16)),
            Tab(text: 'Hotels', icon: Icon(Icons.hotel, size: 16)),
            Tab(text: 'Restaurants', icon: Icon(Icons.restaurant, size: 16)),
            Tab(text: 'Attractions', icon: Icon(Icons.place, size: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Location Status Bar
          _buildLocationStatusBar(),
          
          // Map Container (Placeholder for Google Maps)
          Expanded(
            flex: 3,
            child: _buildMapContainer(),
          ),
          
          // Bottom Sheet with Places List
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Category Filter
                  _buildCategoryFilter(),
                  
                  // Places List
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAllPlacesList(),
                        _buildHotelsList(),
                        _buildRestaurantsList(),
                        _buildAttractionsList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "navigate",
            onPressed: _showNavigationOptions,
            backgroundColor: const Color(0xFF2E7D5A),
            child: const Icon(Icons.navigation, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "filter",
            onPressed: _showMapFilters,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isLocationEnabled ? Colors.green[50] : Colors.red[50],
        border: Border(
          bottom: BorderSide(
            color: _isLocationEnabled ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isLocationEnabled ? Icons.location_on : Icons.location_off,
            color: _isLocationEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isLocationEnabled
                  ? _currentPosition != null
                      ? 'Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                      : 'Location services enabled'
                  : 'Location services disabled. Enable to use navigation features.',
              style: TextStyle(
                color: _isLocationEnabled ? Colors.green[700] : Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
          if (!_isLocationEnabled)
            TextButton(
              onPressed: _checkLocationPermission,
              child: const Text(
                'Enable',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    // Generate markers for current tab
    List<MapMarker> markers = [];
    
    // Sample markers for demonstration
    markers.addAll([
      MapMarker(
        id: 'hotel_1',
        title: 'Sample Hotel',
        subtitle: 'Luxury accommodation',
        latitude: 23.8103,
        longitude: 90.4125,
        color: Colors.blue,
        icon: Icons.hotel,
        position: const Offset(100, 150),
        onTap: () => _showPinInfo('Sample Hotel', 'hotel'),
      ),
      MapMarker(
        id: 'restaurant_1',
        title: 'Sample Restaurant',
        subtitle: 'Local cuisine',
        latitude: 23.8203,
        longitude: 90.4225,
        color: Colors.orange,
        icon: Icons.restaurant,
        position: const Offset(200, 100),
        onTap: () => _showPinInfo('Sample Restaurant', 'restaurant'),
      ),
      MapMarker(
        id: 'attraction_1',
        title: 'Sample Attraction',
        subtitle: 'Historic site',
        latitude: 23.8003,
        longitude: 90.4025,
        color: Colors.green,
        icon: Icons.place,
        position: const Offset(150, 200),
        onTap: () => _showPinInfo('Sample Attraction', 'attraction'),
      ),
    ]);

    return GoogleMapWidget(
      markers: markers,
      showCurrentLocation: _isLocationEnabled,
      onMapTap: (lat, lng) {
        print('Map tapped at: $lat, $lng');
      },
      initialLat: _currentPosition?.latitude,
      initialLng: _currentPosition?.longitude,
    );
  }

  Color _getPinColor(String type) {
    switch (type) {
      case 'hotel':
        return Colors.blue;
      case 'restaurant':
        return Colors.orange;
      case 'attraction':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPinIcon(String type) {
    switch (type) {
      case 'hotel':
        return Icons.hotel;
      case 'restaurant':
        return Icons.restaurant;
      case 'attraction':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Hotels', 'Restaurants', 'Attractions'];
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                _tabController.animateTo(index);
              },
              selectedColor: const Color(0xFF2E7D5A),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllPlacesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Hotels', Icons.hotel, Colors.blue),
        _buildHotelsSample(),
        const SizedBox(height: 16),
        _buildSectionHeader('Restaurants', Icons.restaurant, Colors.orange),
        _buildRestaurantsSample(),
        const SizedBox(height: 16),
        _buildSectionHeader('Attractions', Icons.place, Colors.green),
        _buildAttractionsSample(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelsList() {
    final hotelsAsync = ref.watch(bangladeshHotelsProvider);
    
    return hotelsAsync.when(
      data: (hotels) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return _buildPlaceCard(
            hotel.name,
            hotel.location.address,
            hotel.images.first,
            Icons.hotel,
            Colors.blue,
            () => context.go('/hotel/${hotel.id}'),
            () => _navigateToPlace(
              hotel.location.latitude,
              hotel.location.longitude,
              hotel.name,
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildRestaurantsList() {
    final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
    
    return restaurantsAsync.when(
      data: (restaurants) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return _buildPlaceCard(
            restaurant.name,
            restaurant.location.address,
            restaurant.images.first,
            Icons.restaurant,
            Colors.orange,
            () => context.go('/restaurant/${restaurant.id}'),
            () => _navigateToPlace(
              restaurant.location.latitude,
              restaurant.location.longitude,
              restaurant.name,
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAttractionsList() {
    final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
    
    return attractionsAsync.when(
      data: (attractions) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          final attraction = attractions[index];
          return _buildPlaceCard(
            attraction.name,
            attraction.location.address,
            attraction.images.first,
            Icons.place,
            Colors.green,
            () => context.go('/attraction/${attraction.id}'),
            () => _navigateToPlace(
              attraction.location.latitude,
              attraction.location.longitude,
              attraction.name,
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHotelsSample() {
    return SizedBox(
      height: 120,
      child: Consumer(
        builder: (context, ref, child) {
          final hotelsAsync = ref.watch(bangladeshHotelsProvider);
          return hotelsAsync.when(
            data: (hotels) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotels.take(5).length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return _buildHorizontalPlaceCard(
                  hotel.name,
                  hotel.location.city,
                  hotel.images.first,
                  Icons.hotel,
                  Colors.blue,
                  () => context.go('/hotel/${hotel.id}'),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading hotels')),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantsSample() {
    return SizedBox(
      height: 120,
      child: Consumer(
        builder: (context, ref, child) {
          final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
          return restaurantsAsync.when(
            data: (restaurants) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.take(5).length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return _buildHorizontalPlaceCard(
                  restaurant.name,
                  restaurant.location.city,
                  restaurant.images.first,
                  Icons.restaurant,
                  Colors.orange,
                  () => context.go('/restaurant/${restaurant.id}'),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading restaurants')),
          );
        },
      ),
    );
  }

  Widget _buildAttractionsSample() {
    return SizedBox(
      height: 120,
      child: Consumer(
        builder: (context, ref, child) {
          final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
          return attractionsAsync.when(
            data: (attractions) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: attractions.take(5).length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return _buildHorizontalPlaceCard(
                  attraction.name,
                  attraction.location.city,
                  attraction.images.first,
                  Icons.place,
                  Colors.green,
                  () => context.go('/attraction/${attraction.id}'),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading attractions')),
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard(
    String name,
    String address,
    String imageUrl,
    IconData icon,
    Color color,
    VoidCallback onTap,
    VoidCallback onNavigate,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Navigation button
              IconButton(
                onPressed: onNavigate,
                icon: Icon(
                  Icons.directions,
                  color: color,
                ),
                tooltip: 'Get Directions',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalPlaceCard(
    String name,
    String location,
    String imageUrl,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 60,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              
              // Name
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Location
              Text(
                location,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPinInfo(String name, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getPinIcon(type), color: _getPinColor(type)),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Type: ${type.toUpperCase()}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to details
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('Details'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToPlace(0, 0, name); // Sample coordinates
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D5A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNavigationOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Navigation Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildNavigationOption(
              'Get Directions',
              'Start turn-by-turn navigation',
              Icons.navigation,
              Colors.blue,
              _startNavigation,
            ),
            _buildNavigationOption(
              'Nearby Places',
              'Find places around your location',
              Icons.near_me,
              Colors.green,
              _findNearbyPlaces,
            ),
            _buildNavigationOption(
              'Route Planning',
              'Plan a route with multiple stops',
              Icons.route,
              Colors.orange,
              _planRoute,
            ),
            _buildNavigationOption(
              'Traffic Info',
              'Check current traffic conditions',
              Icons.traffic,
              Colors.red,
              _showTrafficInfo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showMapFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Map Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Show Hotels', Icons.hotel, true),
            _buildFilterOption('Show Restaurants', Icons.restaurant, true),
            _buildFilterOption('Show Attractions', Icons.place, true),
            _buildFilterOption('Show Traffic', Icons.traffic, false),
            _buildFilterOption('Satellite View', Icons.satellite, false),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D5A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon, bool value) {
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon),
      value: value,
      onChanged: (bool newValue) {
        // Handle filter change
      },
      activeThumbColor: const Color(0xFF2E7D5A),
    );
  }

  void _navigateToPlace(double lat, double lng, String placeName) {
    if (!_isLocationEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Navigate to $placeName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Coordinates: $lat, $lng'),
            const SizedBox(height: 16),
            const Text('Choose navigation app:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchExternalNavigation(lat, lng, placeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Google Maps'),
          ),
        ],
      ),
    );
  }

  void _launchExternalNavigation(double lat, double lng, String placeName) {
    // This would normally launch external navigation apps
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Launching navigation to $placeName'),
        backgroundColor: const Color(0xFF2E7D5A),
      ),
    );
  }

  void _startNavigation() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation feature ready for Google Maps integration'),
        backgroundColor: Color(0xFF2E7D5A),
      ),
    );
  }

  void _findNearbyPlaces() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nearby places search ready for implementation'),
        backgroundColor: Color(0xFF2E7D5A),
      ),
    );
  }

  void _planRoute() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Route planning feature coming soon'),
        backgroundColor: Color(0xFF2E7D5A),
      ),
    );
  }

  void _showTrafficInfo() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Traffic information feature coming soon'),
        backgroundColor: Color(0xFF2E7D5A),
      ),
    );
  }
}