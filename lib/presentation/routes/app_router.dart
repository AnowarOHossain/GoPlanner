// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import providers for data
import '../providers/listings_provider.dart';
// Import all screens
import '../screens/profile_screen.dart';
import '../screens/travel_guide_screen.dart';
import '../screens/maps_screen.dart';
import '../screens/explore_screen.dart';
// Import widgets
import '../widgets/image_loader.dart';
// Import data models
import '../../data/models/hotel_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/attraction_model.dart';

// Provider to track navigation history (which pages user visited)
final navigationHistoryProvider = StateNotifierProvider<NavigationHistory, List<String>>((ref) {
  return NavigationHistory();
});

// Class to manage navigation history
class NavigationHistory extends StateNotifier<List<String>> {
  // Start with home page
  NavigationHistory() : super(['/']);

  // Add a new page to history
  void push(String route) {
    // Don't add if it's the same as last page
    if (state.isEmpty || state.last != route) {
      state = [...state, route];
      print(' Navigation history: $state');
    }
  }

  // Go back to previous page
  String? pop() {
    if (state.length > 1) {
      final newState = state.sublist(0, state.length - 1);
      final previousRoute = newState.last;
      state = newState;
      print(' Popped to: $previousRoute, history: $state');
      return previousRoute;
    }
    return null;
  }

  // Clear all history
  void clear() {
    state = ['/'];
  }
}

// Simple provider without code generation for now
final appRouterProvider = Provider<GoRouter>((ref) {
  final navigationHistory = ref.read(navigationHistoryProvider.notifier);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Add navigation listener to track route changes
    redirect: (context, state) {
      final currentRoute = state.uri.toString();
      print(' Navigating to: $currentRoute');
      
      // Add to history when navigating (but not when going back via our back button)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigationHistory.push(currentRoute);
      });
      
      return null; // Allow navigation to proceed
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => BackButtonWrapper(
          child: const ExploreScreen(),
        ),
      ),
      GoRoute(
        path: '/hotels',
        name: 'hotels',
        builder: (context, state) => BackButtonWrapper(
          child: const HotelsScreen(),
        ),
      ),
      GoRoute(
        path: '/hotel/:id',
        name: 'hotel_detail',
        builder: (context, state) {
          final hotelId = state.pathParameters['id']!;
          return BackButtonWrapper(
            child: HotelDetailScreen(hotelId: hotelId),
          );
        },
      ),
      GoRoute(
        path: '/restaurants',
        name: 'restaurants',
        builder: (context, state) => BackButtonWrapper(
          child: const RestaurantsScreen(),
        ),
      ),
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant_detail',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return BackButtonWrapper(
            child: RestaurantDetailScreen(restaurantId: restaurantId),
          );
        },
      ),
      GoRoute(
        path: '/attractions',
        name: 'attractions',
        builder: (context, state) => BackButtonWrapper(
          child: const AttractionsScreen(),
        ),
      ),
      GoRoute(
        path: '/attraction/:id',
        name: 'attraction_detail',
        builder: (context, state) {
          final attractionId = state.pathParameters['id']!;
          return BackButtonWrapper(
            child: AttractionDetailScreen(attractionId: attractionId),
          );
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => BackButtonWrapper(
          child: const CartScreen(),
        ),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => BackButtonWrapper(
          child: const FavoritesScreen(),
        ),
      ),
      GoRoute(
        path: '/itinerary-generator',
        name: 'itinerary_generator',
        builder: (context, state) => BackButtonWrapper(
          child: const TravelGuideScreen(),
        ),
      ),
      GoRoute(
        path: '/itinerary/:id',
        name: 'itinerary_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BackButtonWrapper(
            child: ItineraryDetailScreen(itineraryId: id),
          );
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => BackButtonWrapper(
          child: const MapsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => BackButtonWrapper(
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => BackButtonWrapper(
          child: const SettingsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
    ),
  );
});

// Back button wrapper to handle Android system back button
class BackButtonWrapper extends ConsumerWidget {
  final Widget child;

  const BackButtonWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        print(' Back button pressed, checking navigation history...');
        
        final router = GoRouter.of(context);
        final navigationHistory = ref.read(navigationHistoryProvider.notifier);
        final history = ref.read(navigationHistoryProvider);
        
        print(' Current history: $history');
        
        // Try to pop from our custom history
        final previousRoute = navigationHistory.pop();
        
        if (previousRoute != null && previousRoute != GoRouterState.of(context).uri.toString()) {
          print(' Going back to: $previousRoute');
          router.go(previousRoute);
        } else {
          print(' No previous route, going to home');
          router.go('/');
        }
      },
      child: child,
    );
  }
}

// Home Screen with proper UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'GoPlanner',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFA855F7),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.travel_explore,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  const SizedBox(height: 20),
                  const Text(
                    'Plan Your Perfect Trip',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover amazing places, create itineraries, and manage your travel budget all in one place.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Quick Actions Grid
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildQuickActionCard(
                        context,
                        'Hotels',
                        Icons.hotel,
                        const Color(0xFF3B82F6),
                        '/hotels',
                      ),
                      _buildQuickActionCard(
                        context,
                        'Restaurants',
                        Icons.restaurant,
                        const Color(0xFFEF4444),
                        '/restaurants',
                      ),
                      _buildQuickActionCard(
                        context,
                        'Attractions',
                        Icons.attractions,
                        const Color(0xFF10B981),
                        '/attractions',
                      ),
                      _buildQuickActionCard(
                        context,
                        'Travel Guide',
                        Icons.auto_awesome,
                        const Color(0xFFF59E0B),
                        '/itinerary-generator',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Features Section
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    'Budget Analysis',
                    'Analyze your travel expenses and budget breakdown',
                    Icons.analytics,
                    () => context.go('/cart'),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    'Favorites',
                    'Save your favorite places and experiences',
                    Icons.favorite,
                    () => context.go('/favorites'),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    'Maps & Navigation',
                    'Explore locations with interactive maps',
                    Icons.map,
                    () => context.go('/map'),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/explore');
              break;
            case 2:
              context.go('/cart');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
  
  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6366F1),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class HotelsScreen extends ConsumerStatefulWidget {
  const HotelsScreen({super.key});

  @override
  ConsumerState<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends ConsumerState<HotelsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHotelsAsync = ref.watch(filteredHotelsProvider);
    final divisions = ref.watch(divisionsProvider);
    final hotelTypes = ref.watch(hotelTypesProvider);
    final selectedDivision = ref.watch(selectedDivisionProvider);
    final selectedHotelType = ref.watch(selectedHotelTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels in Bangladesh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search hotels, cities, divisions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Division Filter
                FilterChip(
                  label: Text(selectedDivision ?? 'All Divisions'),
                  selected: selectedDivision != null,
                  onSelected: (selected) {
                    _showDivisionFilter(context, divisions);
                  },
                ),
                const SizedBox(width: 8),
                
                // Hotel Type Filter
                FilterChip(
                  label: Text(selectedHotelType ?? 'All Types'),
                  selected: selectedHotelType != null,
                  onSelected: (selected) {
                    _showHotelTypeFilter(context, hotelTypes);
                  },
                ),
                const SizedBox(width: 8),
                
                // Price Filter
                FilterChip(
                  label: const Text('Price Range'),
                  selected: false,
                  onSelected: (selected) {
                    _showPriceRangeFilter(context);
                  },
                ),
                const SizedBox(width: 8),
                
                // Clear Filters
                if (selectedDivision != null || selectedHotelType != null)
                  ActionChip(
                    label: const Text('Clear Filters'),
                    onPressed: () {
                      ref.read(selectedDivisionProvider.notifier).state = null;
                      ref.read(selectedHotelTypeProvider.notifier).state = null;
                    },
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Hotels List/Grid
          Expanded(
            child: filteredHotelsAsync.when(
              data: (hotels) {
                if (hotels.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hotels found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Try adjusting your search or filters'),
                      ],
                    ),
                  );
                }
                
                return _isGridView 
                    ? _buildGridView(hotels)
                    : _buildListView(hotels);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 80, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading hotels: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(bangladeshHotelsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<HotelModel> hotels) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: hotels.length,
      itemBuilder: (context, index) => _buildHotelCard(hotels[index]),
    );
  }

  Widget _buildListView(List<HotelModel> hotels) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hotels.length,
      itemBuilder: (context, index) => _buildHotelListTile(hotels[index]),
    );
  }

  Widget _buildHotelCard(HotelModel hotel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.go('/hotel/${hotel.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Hotel Image
          Expanded(
            flex: 2,
            child: DecorationImageLoader.networkContainer(
              imageUrl: hotel.images.first,
              width: double.infinity,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getHotelTypeColor(hotel.hotelType),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        hotel.hotelType.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite and Budget buttons
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final favoriteHotelIds = ref.watch(favoriteHotelsProvider);
                            final isFavorite = favoriteHotelIds.contains(hotel.id);
                            return GestureDetector(
                              onTap: () {
                                print(' Hotel favorite button tapped: ${hotel.name}, isFavorite: $isFavorite');
                                if (isFavorite) {
                                  ref.read(favoriteHotelsProvider.notifier).state = 
                                    {...favoriteHotelIds}..remove(hotel.id);
                                  print(' Removed hotel from favorites: ${hotel.id}');
                                } else {
                                  ref.read(favoriteHotelsProvider.notifier).state = 
                                    {...favoriteHotelIds, hotel.id};
                                  print(' Added hotel to favorites: ${hotel.id}');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            final budgetItems = ref.watch(budgetItemsProvider);
                            final isInBudget = budgetItems.any((item) => 
                              item.type == 'hotel' && item.id == hotel.id);
                            return GestureDetector(
                              onTap: () {
                                print(' Hotel budget button tapped: ${hotel.name}, isInBudget: $isInBudget');
                                if (isInBudget) {
                                  ref.read(budgetItemsProvider.notifier).state = 
                                    budgetItems.where((item) => 
                                      !(item.type == 'hotel' && item.id == hotel.id)).toList();
                                  print(' Removed hotel from budget: ${hotel.id}');
                                } else {
                                  final newItem = BudgetItem(
                                    id: hotel.id,
                                    type: 'hotel',
                                    name: hotel.name,
                                    price: hotel.pricePerNight,
                                    currency: '৳',
                                    imageUrl: hotel.images.first,
                                    location: '${hotel.location.city}, ${hotel.division}',
                                    quantity: 1,
                                  );
                                  ref.read(budgetItemsProvider.notifier).state = 
                                    [...budgetItems, newItem];
                                  print(' Added hotel to budget: ${hotel.id}');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                  color: isInBudget ? const Color(0xFF2E7D5A) : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Hotel Info
          Flexible(
            flex: 3,
            child: Container(
              height: 120, // Fixed height to prevent overflow
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${hotel.location.city}, ${hotel.division}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        hotel.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' (${hotel.reviewCount})',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '৳${hotel.pricePerNight.toStringAsFixed(0)}/night',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D5A),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHotelListTile(HotelModel hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: () => context.go('/hotel/${hotel.id}'),
        contentPadding: const EdgeInsets.all(16),
        leading: DecorationImageLoader.networkContainer(
          imageUrl: hotel.images.first,
          width: 80,
          height: 80,
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          hotel.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${hotel.location.city}, ${hotel.division}'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${hotel.rating} (${hotel.reviewCount} reviews)'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '৳${hotel.pricePerNight.toStringAsFixed(0)}/night',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D5A),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getHotelTypeColor(hotel.hotelType),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hotel.hotelType.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getHotelTypeColor(String hotelType) {
    switch (hotelType.toLowerCase()) {
      case 'luxury':
        return Colors.purple;
      case 'business':
        return Colors.blue;
      case 'resort':
        return Colors.green;
      case 'heritage':
        return Colors.orange;
      case 'budget':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showDivisionFilter(BuildContext context, List<String> divisions) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Division',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...divisions.map((division) => ListTile(
              title: Text(division),
              onTap: () {
                ref.read(selectedDivisionProvider.notifier).state = division;
                Navigator.pop(context);
              },
            )),
            ListTile(
              title: const Text('All Divisions'),
              onTap: () {
                ref.read(selectedDivisionProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHotelTypeFilter(BuildContext context, List<String> hotelTypes) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Hotel Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...hotelTypes.map((type) => ListTile(
              title: Text(type.toUpperCase()),
              onTap: () {
                ref.read(selectedHotelTypeProvider.notifier).state = type;
                Navigator.pop(context);
              },
            )),
            ListTile(
              title: const Text('All Types'),
              onTap: () {
                ref.read(selectedHotelTypeProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceRangeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final currentRange = ref.read(priceRangeProvider);
          RangeValues tempRange = currentRange;
          
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Range (per night)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '৳${tempRange.start.round()} - ৳${tempRange.end.round()}',
                  style: const TextStyle(fontSize: 16),
                ),
                RangeSlider(
                  values: tempRange,
                  min: 1000,
                  max: 15000,
                  divisions: 28,
                  labels: RangeLabels(
                    '৳${tempRange.start.round()}',
                    '৳${tempRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      tempRange = values;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(priceRangeProvider.notifier).state = tempRange;
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RestaurantsScreen extends ConsumerStatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  ConsumerState<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends ConsumerState<RestaurantsScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(filteredRestaurantsProvider);
    final searchQuery = ref.watch(restaurantSearchQueryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (value) => ref.read(restaurantSearchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search restaurants, cuisines, locations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => ref.read(restaurantSearchQueryProvider.notifier).state = '',
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Active Filters Chips
          _buildActiveFiltersRow(),
          
          // Restaurants List/Grid
          Expanded(
            child: restaurantsAsync.when(
              data: (restaurants) {
                if (restaurants.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(bangladeshRestaurantsProvider);
                  },
                  child: _isGridView
                      ? _buildGridView(restaurants)
                      : _buildListView(restaurants),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading restaurants: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(bangladeshRestaurantsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    final selectedDivision = ref.watch(selectedRestaurantDivisionProvider);
    final selectedCuisineType = ref.watch(selectedCuisineTypeProvider);
    final selectedPriceRange = ref.watch(selectedPriceRangeProvider);
    
    final hasActiveFilters = selectedDivision != null || 
                           selectedCuisineType != null || 
                           selectedPriceRange != null;
    
    if (!hasActiveFilters) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (selectedDivision != null)
              _buildFilterChip('Division: $selectedDivision', () {
                ref.read(selectedRestaurantDivisionProvider.notifier).state = null;
              }),
            if (selectedCuisineType != null)
              _buildFilterChip('Cuisine: $selectedCuisineType', () {
                ref.read(selectedCuisineTypeProvider.notifier).state = null;
              }),
            if (selectedPriceRange != null)
              _buildFilterChip('Price: $selectedPriceRange', () {
                ref.read(selectedPriceRangeProvider.notifier).state = null;
              }),
            TextButton.icon(
              onPressed: () {
                ref.read(selectedRestaurantDivisionProvider.notifier).state = null;
                ref.read(selectedCuisineTypeProvider.notifier).state = null;
                ref.read(selectedPriceRangeProvider.notifier).state = null;
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
        deleteIconColor: const Color(0xFF2E7D5A),
      ),
    );
  }

  Widget _buildGridView(List<RestaurantModel> restaurants) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return _buildRestaurantCard(restaurant);
      },
    );
  }

  Widget _buildListView(List<RestaurantModel> restaurants) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return _buildRestaurantListTile(restaurant);
      },
    );
  }

  Widget _buildRestaurantCard(RestaurantModel restaurant) {
    return InkWell(
      onTap: () => context.go('/restaurant/${restaurant.id}'),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Expanded(
              flex: 2,
              child: DecorationImageLoader.networkContainer(
                imageUrl: restaurant.images.first,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    // Price Range Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriceRangeColor(restaurant.priceRange),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          restaurant.priceRange,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Halal Badge
                    if (restaurant.isHalal)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    // Favorite and Budget buttons
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final favoriteRestaurantIds = ref.watch(favoriteRestaurantsProvider);
                              final isFavorite = favoriteRestaurantIds.contains(restaurant.id);
                              return GestureDetector(
                                onTap: () {
                                  print(' Restaurant favorite button tapped: ${restaurant.name}, isFavorite: $isFavorite');
                                  if (isFavorite) {
                                    ref.read(favoriteRestaurantsProvider.notifier).state = 
                                      {...favoriteRestaurantIds}..remove(restaurant.id);
                                    print(' Removed restaurant from favorites: ${restaurant.id}');
                                  } else {
                                    ref.read(favoriteRestaurantsProvider.notifier).state = 
                                      {...favoriteRestaurantIds, restaurant.id};
                                    print(' Added restaurant to favorites: ${restaurant.id}');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Consumer(
                            builder: (context, ref, child) {
                              final budgetItems = ref.watch(budgetItemsProvider);
                              final isInBudget = budgetItems.any((item) => 
                                item.type == 'restaurant' && item.id == restaurant.id);
                              return GestureDetector(
                                onTap: () {
                                  print(' Restaurant budget button tapped: ${restaurant.name}, isInBudget: $isInBudget');
                                  if (isInBudget) {
                                    ref.read(budgetItemsProvider.notifier).state = 
                                      budgetItems.where((item) => 
                                        !(item.type == 'restaurant' && item.id == restaurant.id)).toList();
                                    print(' Removed restaurant from budget: ${restaurant.id}');
                                  } else {
                                    final newItem = BudgetItem(
                                      id: restaurant.id,
                                      type: 'restaurant',
                                      name: restaurant.name,
                                      price: restaurant.averageCostForTwo,
                                      currency: '৳',
                                      imageUrl: restaurant.images.first,
                                      location: '${restaurant.location.city}, ${restaurant.division}',
                                      quantity: 1,
                                    );
                                    ref.read(budgetItemsProvider.notifier).state = 
                                      [...budgetItems, newItem];
                                    print(' Added restaurant to budget: ${restaurant.id}');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: isInBudget ? const Color(0xFF2E7D5A) : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Restaurant Info
            Flexible(
              flex: 3,
              child: Container(
                height: 120, // Fixed height to prevent overflow
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    // Cuisine Type
                    Text(
                      restaurant.cuisineType,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            restaurant.location.city,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    
                    // Rating and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          '৳${restaurant.averageCostForTwo.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D5A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantListTile(RestaurantModel restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.go('/restaurant/${restaurant.id}'),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Restaurant Image
                DecorationImageLoader.networkContainer(
                  imageUrl: restaurant.images.first,
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      if (restaurant.isHalal)
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Restaurant Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Price Range
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getPriceRangeColor(restaurant.priceRange),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              restaurant.priceRange,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Cuisine Type
                      Text(
                        restaurant.cuisineType,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${restaurant.location.city}, ${restaurant.division}',
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
                      const SizedBox(height: 8),
                      
                      // Rating, Reviews, and Price
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                restaurant.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${restaurant.reviewCount})',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '৳${restaurant.averageCostForTwo.toStringAsFixed(0)} for two',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D5A),
                            ),
                          ),
                        ],
                      ),
                      
                      // Amenities (if available)
                      if (restaurant.hasDelivery || restaurant.hasReservation)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              if (restaurant.hasDelivery)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Delivery',
                                    style: TextStyle(fontSize: 10, color: Colors.blue),
                                  ),
                                ),
                              if (restaurant.hasReservation)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Reservations',
                                    style: TextStyle(fontSize: 10, color: Colors.orange),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No restaurants found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(restaurantSearchQueryProvider.notifier).state = '';
              ref.read(selectedRestaurantDivisionProvider.notifier).state = null;
              ref.read(selectedCuisineTypeProvider.notifier).state = null;
              ref.read(selectedPriceRangeProvider.notifier).state = null;
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriceRangeColor(String priceRange) {
    switch (priceRange.toLowerCase()) {
      case 'budget':
        return Colors.green;
      case 'mid-range':
        return Colors.orange;
      case 'fine dining':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RestaurantFilterBottomSheet(),
    );
  }
}

class AttractionsScreen extends ConsumerStatefulWidget {
  const AttractionsScreen({super.key});

  @override
  ConsumerState<AttractionsScreen> createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends ConsumerState<AttractionsScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final attractionsAsync = ref.watch(filteredAttractionsProvider);
    final searchQuery = ref.watch(attractionSearchQueryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attractions'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (value) => ref.read(attractionSearchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search attractions, categories, locations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => ref.read(attractionSearchQueryProvider.notifier).state = '',
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Active Filters Chips
          _buildActiveFiltersRow(),
          
          // Attractions List/Grid
          Expanded(
            child: attractionsAsync.when(
              data: (attractions) {
                if (attractions.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(bangladeshAttractionsProvider);
                  },
                  child: _isGridView
                      ? _buildGridView(attractions)
                      : _buildListView(attractions),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading attractions: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(bangladeshAttractionsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    final selectedDivision = ref.watch(selectedAttractionDivisionProvider);
    final selectedCategory = ref.watch(selectedAttractionCategoryProvider);
    final selectedPeriod = ref.watch(selectedHistoricalPeriodProvider);
    
    final hasActiveFilters = selectedDivision != null || 
                           selectedCategory != null || 
                           selectedPeriod != null;
    
    if (!hasActiveFilters) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (selectedDivision != null)
              _buildFilterChip('Division: $selectedDivision', () {
                ref.read(selectedAttractionDivisionProvider.notifier).state = null;
              }),
            if (selectedCategory != null)
              _buildFilterChip('Category: $selectedCategory', () {
                ref.read(selectedAttractionCategoryProvider.notifier).state = null;
              }),
            if (selectedPeriod != null)
              _buildFilterChip('Period: $selectedPeriod', () {
                ref.read(selectedHistoricalPeriodProvider.notifier).state = null;
              }),
            TextButton.icon(
              onPressed: () {
                ref.read(selectedAttractionDivisionProvider.notifier).state = null;
                ref.read(selectedAttractionCategoryProvider.notifier).state = null;
                ref.read(selectedHistoricalPeriodProvider.notifier).state = null;
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
        deleteIconColor: const Color(0xFF2E7D5A),
      ),
    );
  }

  Widget _buildGridView(List<AttractionModel> attractions) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        final attraction = attractions[index];
        return _buildAttractionCard(attraction);
      },
    );
  }

  Widget _buildListView(List<AttractionModel> attractions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        final attraction = attractions[index];
        return _buildAttractionListTile(attraction);
      },
    );
  }

  Widget _buildAttractionCard(AttractionModel attraction) {
    return InkWell(
      onTap: () => context.go('/attraction/${attraction.id}'),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attraction Image
            Expanded(
              flex: 2,
              child: DecorationImageLoader.networkContainer(
                imageUrl: attraction.images.first,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    // Category Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(attraction.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          attraction.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Free Badge
                    if (attraction.isFree)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: Icon(
                          Icons.money_off,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    // Favorite and Budget buttons
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final favoriteAttractionIds = ref.watch(favoriteAttractionsProvider);
                              final isFavorite = favoriteAttractionIds.contains(attraction.id);
                              return GestureDetector(
                                onTap: () {
                                  if (isFavorite) {
                                    ref.read(favoriteAttractionsProvider.notifier).state = 
                                      {...favoriteAttractionIds}..remove(attraction.id);
                                  } else {
                                    ref.read(favoriteAttractionsProvider.notifier).state = 
                                      {...favoriteAttractionIds, attraction.id};
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Consumer(
                            builder: (context, ref, child) {
                              final budgetItems = ref.watch(budgetItemsProvider);
                              final isInBudget = budgetItems.any((item) => 
                                item.type == 'attraction' && item.id == attraction.id);
                              return GestureDetector(
                                onTap: () {
                                  if (isInBudget) {
                                    ref.read(budgetItemsProvider.notifier).state = 
                                      budgetItems.where((item) => 
                                        !(item.type == 'attraction' && item.id == attraction.id)).toList();
                                  } else {
                                    final newItem = BudgetItem(
                                      id: attraction.id,
                                      type: 'attraction',
                                      name: attraction.name,
                                      price: attraction.entryFee ?? 0.0,
                                      currency: '৳',
                                      imageUrl: attraction.images.first,
                                      location: '${attraction.location.city}, ${attraction.division}',
                                      quantity: 1,
                                    );
                                    ref.read(budgetItemsProvider.notifier).state = 
                                      [...budgetItems, newItem];
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: isInBudget ? const Color(0xFF2E7D5A) : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Attraction Info
            Flexible(
              flex: 3,
              child: Container(
                height: 120, // Fixed height to prevent overflow
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      attraction.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${attraction.location.city}, ${attraction.division}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Rating and Entry Fee
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          attraction.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${attraction.reviewCount})',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          attraction.isFree ? 'Free' : '৳${attraction.entryFee!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: attraction.isFree ? Colors.green : const Color(0xFF2E7D5A),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractionListTile(AttractionModel attraction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.go('/attraction/${attraction.id}'),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Attraction Image
                DecorationImageLoader.networkContainer(
                  imageUrl: attraction.images.first,
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      if (attraction.isFree)
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.money_off,
                            color: Colors.green,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Attraction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Category
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              attraction.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(attraction.category),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              attraction.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Subcategory
                      Text(
                        attraction.subcategory,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${attraction.location.city}, ${attraction.division}',
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
                      const SizedBox(height: 8),
                      
                      // Rating, Reviews, and Entry Fee
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                attraction.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${attraction.reviewCount})',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            attraction.formattedEntryFee,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D5A),
                            ),
                          ),
                        ],
                      ),
                      
                      // Duration and Best Time
                      if (attraction.estimatedDuration > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  attraction.formattedDuration,
                                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                                ),
                              ),
                              if (attraction.bestTimeToVisit.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    attraction.bestTimeToVisit,
                                    style: const TextStyle(fontSize: 10, color: Colors.orange),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.attractions,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No attractions found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(attractionSearchQueryProvider.notifier).state = '';
              ref.read(selectedAttractionDivisionProvider.notifier).state = null;
              ref.read(selectedAttractionCategoryProvider.notifier).state = null;
              ref.read(selectedHistoricalPeriodProvider.notifier).state = null;
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'historical':
        return Colors.brown;
      case 'natural':
        return Colors.green;
      case 'religious':
        return Colors.purple;
      case 'archaeological':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AttractionFilterBottomSheet(),
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetItems = ref.watch(budgetItemsProvider);
    final totalBudget = ref.watch(totalBudgetProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Analysis'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
          if (budgetItems.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(budgetItemsProvider.notifier).state = [];
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: budgetItems.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Budget Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2E7D5A),
                        const Color(0xFF2E7D5A).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '৳${totalBudget.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${budgetItems.length} items in budget',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Budget Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: budgetItems.length,
                    itemBuilder: (context, index) {
                      final item = budgetItems[index];
                      return _buildBudgetItem(item, ref, index);
                    },
                  ),
                ),
                
                // Budget Breakdown
                _buildBudgetBreakdown(budgetItems, totalBudget),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics,
            size: 80,
            color: Color(0xFF6366F1),
          ),
          SizedBox(height: 16),
          Text(
            'No Budget Items',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Add hotels, restaurants, or attractions to start planning your budget',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(BudgetItem item, WidgetRef ref, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Item Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTypeColor(item.type),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.location,
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${item.currency}${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D5A),
                          ),
                        ),
                        if (item.quantity > 1) ...[
                          const SizedBox(width: 8),
                          Text(
                            'x${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          '${item.currency}${(item.price * item.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Quantity Controls and Remove
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _updateQuantity(item, -1, ref),
                        icon: const Icon(Icons.remove_circle_outline),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => _updateQuantity(item, 1, ref),
                        icon: const Icon(Icons.add_circle_outline),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _removeItem(index, ref),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetBreakdown(List<BudgetItem> items, double total) {
    final Map<String, double> breakdown = {};
    for (final item in items) {
      breakdown[item.type] = (breakdown[item.type] ?? 0) + (item.price * item.quantity);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...breakdown.entries.map((entry) {
            final percentage = (entry.value / total * 100);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getTypeColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '৳${entry.value.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${percentage.toStringAsFixed(1)}%)',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'hotels':
        return Colors.blue;
      case 'restaurants':
        return Colors.orange;
      case 'attractions':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _updateQuantity(BudgetItem item, int delta, WidgetRef ref) {
    final items = ref.read(budgetItemsProvider);
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final newQuantity = (items[index].quantity + delta).clamp(1, 99);
      final updatedItems = [...items];
      updatedItems[index] = items[index].copyWith(quantity: newQuantity);
      ref.read(budgetItemsProvider.notifier).state = updatedItems;
    }
  }

  void _removeItem(int index, WidgetRef ref) {
    final items = ref.read(budgetItemsProvider);
    final updatedItems = [...items];
    updatedItems.removeAt(index);
    ref.read(budgetItemsProvider.notifier).state = updatedItems;
  }
}

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(allFavoritesProvider);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: const Color(0xFF2E7D5A),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => context.go('/'),
              tooltip: 'Go to Home',
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Hotels', icon: Icon(Icons.hotel)),
              Tab(text: 'Restaurants', icon: Icon(Icons.restaurant)),
              Tab(text: 'Attractions', icon: Icon(Icons.attractions)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFavoritesList(favorites['hotels'] ?? [], 'hotels', ref),
            _buildFavoritesList(favorites['restaurants'] ?? [], 'restaurants', ref),
            _buildFavoritesList(favorites['attractions'] ?? [], 'attractions', ref),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<dynamic> items, String type, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getTypeIcon(type),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorite ${type} yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add ${type} to favorites to see them here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildFavoriteItem(item, type, ref);
      },
    );
  }

  Widget _buildFavoriteItem(dynamic item, String type, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Item Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${item.location.city}, ${type == 'hotels' ? item.division : type == 'restaurants' ? item.division : item.division}',
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          _getItemPrice(item, type),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D5A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeFromFavorites(item.id, type, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF2E7D5A)),
                    onPressed: () => _addToBudget(item, type, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'hotels':
        return Icons.hotel;
      case 'restaurants':
        return Icons.restaurant;
      case 'attractions':
        return Icons.attractions;
      default:
        return Icons.favorite;
    }
  }

  String _getItemPrice(dynamic item, String type) {
    switch (type) {
      case 'hotels':
        return '৳${item.pricePerNight.toStringAsFixed(0)}/night';
      case 'restaurants':
        return '৳${item.averageCostForTwo.toStringAsFixed(0)} for two';
      case 'attractions':
        return item.entryFee != null && item.entryFee > 0 
            ? '৳${item.entryFee.toStringAsFixed(0)}' 
            : 'Free';
      default:
        return '';
    }
  }

  void _removeFromFavorites(String itemId, String type, WidgetRef ref) {
    switch (type) {
      case 'hotels':
        final favorites = ref.read(favoriteHotelsProvider);
        ref.read(favoriteHotelsProvider.notifier).state = {...favorites}..remove(itemId);
        break;
      case 'restaurants':
        final favorites = ref.read(favoriteRestaurantsProvider);
        ref.read(favoriteRestaurantsProvider.notifier).state = {...favorites}..remove(itemId);
        break;
      case 'attractions':
        final favorites = ref.read(favoriteAttractionsProvider);
        ref.read(favoriteAttractionsProvider.notifier).state = {...favorites}..remove(itemId);
        break;
    }
  }

  void _addToBudget(dynamic item, String type, WidgetRef ref) {
    final budgetItems = ref.read(budgetItemsProvider);
    final newItem = BudgetItem(
      id: item.id,
      name: item.name,
      type: type,
      price: _getItemPriceValue(item, type),
      currency: '৳',
      imageUrl: item.images.first,
      location: '${item.location.city}, ${item.division}',
    );
    
    // Check if item already exists in budget
    final existingIndex = budgetItems.indexWhere((budgetItem) => budgetItem.id == item.id);
    if (existingIndex != -1) {
      // Update quantity if item exists
      final updatedItems = [...budgetItems];
      updatedItems[existingIndex] = budgetItems[existingIndex].copyWith(
        quantity: budgetItems[existingIndex].quantity + 1,
      );
      ref.read(budgetItemsProvider.notifier).state = updatedItems;
    } else {
      // Add new item
      ref.read(budgetItemsProvider.notifier).state = [...budgetItems, newItem];
    }
  }

  double _getItemPriceValue(dynamic item, String type) {
    switch (type) {
      case 'hotels':
        return item.pricePerNight.toDouble();
      case 'restaurants':
        return item.averageCostForTwo.toDouble();
      case 'attractions':
        return item.entryFee?.toDouble() ?? 0.0;
      default:
        return 0.0;
    }
  }
}

class ItineraryDetailScreen extends StatelessWidget {
  final String itineraryId;
  
  const ItineraryDetailScreen({
    super.key,
    required this.itineraryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: Center(
        child: Text('Itinerary Details for ID: $itineraryId'),
      ),
    );
  }
}

class AttractionDetailScreen extends ConsumerWidget {
  final String attractionId;
  
  const AttractionDetailScreen({super.key, required this.attractionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractionsAsync = ref.watch(bangladeshAttractionsProvider);
    
    return attractionsAsync.when(
      data: (attractions) {
        final attraction = attractions.firstWhere(
          (a) => a.id == attractionId,
          orElse: () => attractions.first,
        );
        
        return Scaffold(
          appBar: AppBar(
            title: Text(attraction.name),
            backgroundColor: const Color(0xFF2E7D5A),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => context.go('/'),
                tooltip: 'Go to Home',
              ),
              // Favorite Button
              Consumer(
                builder: (context, ref, child) {
                  final favoriteAttractionIds = ref.watch(favoriteAttractionsProvider);
                  final isFavorite = favoriteAttractionIds.contains(attraction.id);
                  return IconButton(
                    onPressed: () {
                      print(' Attraction detail favorite button tapped: ${attraction.name}, isFavorite: $isFavorite');
                      if (isFavorite) {
                        ref.read(favoriteAttractionsProvider.notifier).state = 
                          {...favoriteAttractionIds}..remove(attraction.id);
                        print(' Removed attraction from favorites: ${attraction.id}');
                      } else {
                        ref.read(favoriteAttractionsProvider.notifier).state = 
                          {...favoriteAttractionIds, attraction.id};
                        print(' Added attraction to favorites: ${attraction.id}');
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                  );
                },
              ),
              // Budget Button
              Consumer(
                builder: (context, ref, child) {
                  final budgetItems = ref.watch(budgetItemsProvider);
                  final isInBudget = budgetItems.any((item) => 
                    item.type == 'attraction' && item.id == attraction.id);
                  return IconButton(
                    onPressed: () {
                      print(' Attraction detail budget button tapped: ${attraction.name}, isInBudget: $isInBudget');
                      if (isInBudget) {
                        ref.read(budgetItemsProvider.notifier).state = 
                          budgetItems.where((item) => 
                            !(item.type == 'attraction' && item.id == attraction.id)).toList();
                        print(' Removed attraction from budget: ${attraction.id}');
                      } else {
                        final newItem = BudgetItem(
                          id: attraction.id,
                          type: 'attraction',
                          name: attraction.name,
                          price: attraction.entryFee ?? 0.0,
                          currency: '৳',
                          imageUrl: attraction.images.first,
                          location: '${attraction.location.city}, ${attraction.division}',
                          quantity: 1,
                        );
                        ref.read(budgetItemsProvider.notifier).state = 
                          [...budgetItems, newItem];
                        print(' Added attraction to budget: ${attraction.id}');
                      }
                    },
                    icon: Icon(
                      isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                      color: isInBudget ? const Color(0xFF2E7D5A) : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Attraction Images
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: attraction.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(attraction.images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Attraction Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Category
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              attraction.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(attraction.category),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              attraction.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Subcategory
                      Text(
                        attraction.subcategory,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Rating and Entry Fee
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${attraction.rating} (${attraction.reviewCount} reviews)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            attraction.formattedEntryFee,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D5A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        attraction.description,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      
                      // Quick Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.location_on, 'Location', 
                                  '${attraction.location.city}, ${attraction.division}'),
                              _buildInfoRow(Icons.access_time, 'Duration', 
                                  attraction.formattedDuration),
                              _buildInfoRow(Icons.wb_sunny, 'Best Time', 
                                  attraction.bestTimeToVisit),
                              _buildInfoRow(Icons.schedule, 'Hours', 
                                  '${attraction.openingHours} - ${attraction.closingHours}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          // Save to Favorites Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final favoriteAttractionIds = ref.watch(favoriteAttractionsProvider);
                                final isFavorite = favoriteAttractionIds.contains(attraction.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Attraction Save button tapped: ${attraction.name}, isFavorite: $isFavorite');
                                    if (isFavorite) {
                                      ref.read(favoriteAttractionsProvider.notifier).state = 
                                        {...favoriteAttractionIds}..remove(attraction.id);
                                      print(' Removed attraction from favorites: ${attraction.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from favorites')),
                                      );
                                    } else {
                                      ref.read(favoriteAttractionsProvider.notifier).state = 
                                        {...favoriteAttractionIds, attraction.id};
                                      print(' Added attraction to favorites: ${attraction.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Saved to favorites!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey[600],
                                  ),
                                  label: Text(
                                    isFavorite ? 'Added to Favorite' : 'Add to Favorite',
                                    style: TextStyle(
                                      color: isFavorite ? Colors.red : Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFavorite ? Colors.red.withValues(alpha: 0.1) : Colors.grey[100],
                                    elevation: 0,
                                    side: BorderSide(
                                      color: isFavorite ? Colors.red : Colors.grey[300]!,
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Add to Budget Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final budgetItems = ref.watch(budgetItemsProvider);
                                final isInBudget = budgetItems.any((item) => 
                                  item.type == 'attraction' && item.id == attraction.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Attraction Budget button tapped: ${attraction.name}, isInBudget: $isInBudget');
                                    if (isInBudget) {
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        budgetItems.where((item) => 
                                          !(item.type == 'attraction' && item.id == attraction.id)).toList();
                                      print(' Removed attraction from budget: ${attraction.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from budget')),
                                      );
                                    } else {
                                      final newItem = BudgetItem(
                                        id: attraction.id,
                                        type: 'attraction',
                                        name: attraction.name,
                                        price: attraction.entryFee ?? 0.0,
                                        currency: '৳',
                                        imageUrl: attraction.images.first,
                                        location: '${attraction.location.city}, ${attraction.division}',
                                        quantity: 1,
                                      );
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        [...budgetItems, newItem];
                                      print(' Added attraction to budget: ${attraction.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to budget!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isInBudget ? 'In Budget' : 'Add to Budget',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInBudget ? Colors.green : const Color(0xFF2E7D5A),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading attraction: $error')),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D5A)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'historical':
        return Colors.brown;
      case 'natural':
        return Colors.green;
      case 'religious':
        return Colors.purple;
      case 'archaeological':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class AttractionFilterBottomSheet extends ConsumerStatefulWidget {
  const AttractionFilterBottomSheet({super.key});

  @override
  ConsumerState<AttractionFilterBottomSheet> createState() => _AttractionFilterBottomSheetState();
}

class _AttractionFilterBottomSheetState extends ConsumerState<AttractionFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final divisions = ref.watch(attractionDivisionsProvider);
    final categories = ref.watch(attractionCategoriesProvider);
    final periods = ref.watch(historicalPeriodsProvider);
    
    final selectedDivision = ref.watch(selectedAttractionDivisionProvider);
    final selectedCategory = ref.watch(selectedAttractionCategoryProvider);
    final selectedPeriod = ref.watch(selectedHistoricalPeriodProvider);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Attractions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(selectedAttractionDivisionProvider.notifier).state = null;
                        ref.read(selectedAttractionCategoryProvider.notifier).state = null;
                        ref.read(selectedHistoricalPeriodProvider.notifier).state = null;
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Division Filter
                const Text(
                  'Division',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: divisions.map((division) {
                    final isSelected = selectedDivision == division;
                    return FilterChip(
                      label: Text(division),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedAttractionDivisionProvider.notifier).state = 
                            selected ? division : null;
                      },
                      selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF2E7D5A),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Category Filter
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedAttractionCategoryProvider.notifier).state = 
                            selected ? category : null;
                      },
                      selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF2E7D5A),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Historical Period Filter
                const Text(
                  'Historical Period',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: periods.map((period) {
                    final isSelected = selectedPeriod == period;
                    return FilterChip(
                      label: Text(period),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedHistoricalPeriodProvider.notifier).state = 
                            selected ? period : null;
                      },
                      selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF2E7D5A),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 32),
                
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D5A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HotelDetailScreen extends ConsumerStatefulWidget {
  final String hotelId;
  
  const HotelDetailScreen({
    super.key,
    required this.hotelId,
  });

  @override
  ConsumerState<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends ConsumerState<HotelDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _imageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _imageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotelsAsync = ref.watch(bangladeshHotelsProvider);
    
    return hotelsAsync.when(
      data: (hotels) {
        final hotel = hotels.firstWhere(
          (h) => h.id == widget.hotelId,
          orElse: () => hotels.first, // Fallback to first hotel if not found
        );
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Image Gallery
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () => context.go('/'),
                    tooltip: 'Go to Home',
                  ),
                  // Favorite Button
                  Consumer(
                    builder: (context, ref, child) {
                      final favoriteHotelIds = ref.watch(favoriteHotelsProvider);
                      final isFavorite = favoriteHotelIds.contains(hotel.id);
                      return IconButton(
                        onPressed: () {
                          print(' Hotel detail favorite button tapped: ${hotel.name}, isFavorite: $isFavorite');
                          if (isFavorite) {
                            ref.read(favoriteHotelsProvider.notifier).state = 
                              {...favoriteHotelIds}..remove(hotel.id);
                            print(' Removed hotel from favorites: ${hotel.id}');
                          } else {
                            ref.read(favoriteHotelsProvider.notifier).state = 
                              {...favoriteHotelIds, hotel.id};
                            print(' Added hotel to favorites: ${hotel.id}');
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                      );
                    },
                  ),
                  // Budget Button
                  Consumer(
                    builder: (context, ref, child) {
                      final budgetItems = ref.watch(budgetItemsProvider);
                      final isInBudget = budgetItems.any((item) => 
                        item.type == 'hotel' && item.id == hotel.id);
                      return IconButton(
                        onPressed: () {
                          print(' Hotel detail budget button tapped: ${hotel.name}, isInBudget: $isInBudget');
                          if (isInBudget) {
                            ref.read(budgetItemsProvider.notifier).state = 
                              budgetItems.where((item) => 
                                !(item.type == 'hotel' && item.id == hotel.id)).toList();
                            print(' Removed hotel from budget: ${hotel.id}');
                          } else {
                            final newItem = BudgetItem(
                              id: hotel.id,
                              type: 'hotel',
                              name: hotel.name,
                              price: hotel.pricePerNight,
                              currency: '৳',
                              imageUrl: hotel.images.first,
                              location: '${hotel.location.city}, ${hotel.division}',
                              quantity: 1,
                            );
                            ref.read(budgetItemsProvider.notifier).state = 
                              [...budgetItems, newItem];
                            print(' Added hotel to budget: ${hotel.id}');
                          }
                        },
                        icon: Icon(
                          isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                          color: isInBudget ? const Color(0xFF2E7D5A) : Colors.white,
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image Gallery
                      PageView.builder(
                        controller: _imageController,
                        itemCount: hotel.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(hotel.images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Image Indicators
                      if (hotel.images.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: hotel.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == entry.key
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      // Hotel Type Badge
                      Positioned(
                        top: 50,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getHotelTypeColor(hotel.hotelType),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hotel.hotelType.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Hotel Information
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel Name and Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${hotel.location.address}, ${hotel.location.city}, ${hotel.division}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      hotel.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${hotel.reviewCount} reviews',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Price and Booking Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2E7D5A).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '৳${hotel.pricePerNight.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D5A),
                                  ),
                                ),
                                const Text(
                                  'per night',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Check-in: ${hotel.checkInTime}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Check-out: ${hotel.checkOutTime}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${hotel.totalRooms} rooms available',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Tabs for different sections
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF2E7D5A),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF2E7D5A),
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Amenities'),
                          Tab(text: 'Location'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Tab Content
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAboutTab(hotel),
                            _buildAmenitiesTab(hotel),
                            _buildLocationTab(hotel),
                            _buildReviewsTab(hotel),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          // Save to Favorites Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final favoriteHotelIds = ref.watch(favoriteHotelsProvider);
                                final isFavorite = favoriteHotelIds.contains(hotel.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Hotel Save button tapped: ${hotel.name}, isFavorite: $isFavorite');
                                    if (isFavorite) {
                                      ref.read(favoriteHotelsProvider.notifier).state = 
                                        {...favoriteHotelIds}..remove(hotel.id);
                                      print(' Removed hotel from favorites: ${hotel.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from favorites')),
                                      );
                                    } else {
                                      ref.read(favoriteHotelsProvider.notifier).state = 
                                        {...favoriteHotelIds, hotel.id};
                                      print(' Added hotel to favorites: ${hotel.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Saved to favorites!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey[600],
                                  ),
                                  label: Text(
                                    isFavorite ? 'Added to Favorite' : 'Add to Favorite',
                                    style: TextStyle(
                                      color: isFavorite ? Colors.red : Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFavorite ? Colors.red.withValues(alpha: 0.1) : Colors.grey[100],
                                    elevation: 0,
                                    side: BorderSide(
                                      color: isFavorite ? Colors.red : Colors.grey[300]!,
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Add to Budget Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final budgetItems = ref.watch(budgetItemsProvider);
                                final isInBudget = budgetItems.any((item) => 
                                  item.type == 'hotel' && item.id == hotel.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Hotel Budget button tapped: ${hotel.name}, isInBudget: $isInBudget');
                                    if (isInBudget) {
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        budgetItems.where((item) => 
                                          !(item.type == 'hotel' && item.id == hotel.id)).toList();
                                      print(' Removed hotel from budget: ${hotel.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from budget')),
                                      );
                                    } else {
                                      final newItem = BudgetItem(
                                        id: hotel.id,
                                        type: 'hotel',
                                        name: hotel.name,
                                        price: hotel.pricePerNight,
                                        currency: '৳',
                                        imageUrl: hotel.images.first,
                                        location: '${hotel.location.city}, ${hotel.division}',
                                        quantity: 1,
                                      );
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        [...budgetItems, newItem];
                                      print(' Added hotel to budget: ${hotel.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to budget!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isInBudget ? 'In Budget' : 'Add to Budget',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInBudget ? Colors.green : const Color(0xFF2E7D5A),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading hotel: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/hotels'),
                child: const Text('Back to Hotels'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab(HotelModel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            hotel.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          
          const Text(
            'Hotel Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow('Hotel Type', hotel.hotelType.toUpperCase()),
          _buildInfoRow('Total Rooms', '${hotel.totalRooms} rooms'),
          _buildInfoRow('Check-in', hotel.checkInTime),
          _buildInfoRow('Check-out', hotel.checkOutTime),
          _buildInfoRow('Parking', hotel.hasParking ? 'Available' : 'Not Available'),
          _buildInfoRow('Airport Transfer', hotel.hasAirport ? 'Available' : 'Not Available'),
          
          if (hotel.contactPhone != null) _buildInfoRow('Phone', hotel.contactPhone!),
          if (hotel.website != null) _buildInfoRow('Website', hotel.website!),
        ],
      ),
    );
  }

  Widget _buildAmenitiesTab(HotelModel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hotel Amenities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hotel.amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2E7D5A).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 16,
                      color: const Color(0xFF2E7D5A),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D5A),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(HotelModel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow('Address', hotel.location.address),
          _buildInfoRow('City', hotel.location.city),
          _buildInfoRow('Division', hotel.division),
          _buildInfoRow('District', hotel.district),
          
          const SizedBox(height: 20),
          
          const Text(
            'Nearby Attractions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...hotel.nearbyAttractions.map((attraction) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.attractions, size: 16, color: Color(0xFF2E7D5A)),
                const SizedBox(width: 8),
                Text(attraction),
              ],
            ),
          )),
          
          const SizedBox(height: 20),
          
          // Placeholder for map
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Map view coming soon'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(HotelModel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Sample reviews (in a real app, these would come from a reviews API)
          _buildReviewItem(
            'Sarah Ahmed',
            4.5,
            'Excellent hotel with amazing service! The staff was very helpful and the rooms were clean and comfortable.',
            '2 days ago',
          ),
          _buildReviewItem(
            'Mohammad Rahman',
            5.0,
            'Perfect location and great amenities. The breakfast was delicious and the view from my room was stunning.',
            '1 week ago',
          ),
          _buildReviewItem(
            'Fatima Khan',
            4.0,
            'Nice hotel overall. Good value for money. The pool area could be improved but everything else was great.',
            '2 weeks ago',
          ),
          
          const SizedBox(height: 20),
          
          Center(
            child: OutlinedButton(
              onPressed: () {
                // In a real app, this would show all reviews
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All reviews coming soon!')),
                );
              },
              child: const Text('View All Reviews'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, double rating, String comment, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2E7D5A),
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'free wifi':
      case 'wifi':
        return Icons.wifi;
      case 'swimming pool':
      case 'pool':
        return Icons.pool;
      case 'spa':
        return Icons.spa;
      case 'fitness center':
      case 'gym':
        return Icons.fitness_center;
      case 'restaurant':
        return Icons.restaurant;
      case 'business center':
        return Icons.business_center;
      case 'room service':
        return Icons.room_service;
      case 'beach access':
        return Icons.beach_access;
      case 'airport shuttle':
      case 'airport transfer':
        return Icons.airport_shuttle;
      case 'conference hall':
      case 'meeting rooms':
        return Icons.meeting_room;
      case 'car parking':
      case 'parking':
        return Icons.local_parking;
      default:
        return Icons.check_circle;
    }
  }

  Color _getHotelTypeColor(String hotelType) {
    switch (hotelType.toLowerCase()) {
      case 'luxury':
        return Colors.purple;
      case 'business':
        return Colors.blue;
      case 'resort':
        return Colors.green;
      case 'heritage':
        return Colors.orange;
      case 'budget':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class RestaurantFilterBottomSheet extends ConsumerStatefulWidget {
  const RestaurantFilterBottomSheet({super.key});

  @override
  ConsumerState<RestaurantFilterBottomSheet> createState() => _RestaurantFilterBottomSheetState();
}

class _RestaurantFilterBottomSheetState extends ConsumerState<RestaurantFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final divisions = ref.watch(restaurantDivisionsProvider);
    final cuisineTypes = ref.watch(cuisineTypesProvider);
    final priceRanges = ref.watch(priceRangesProvider);
    
    final selectedDivision = ref.watch(selectedRestaurantDivisionProvider);
    final selectedCuisineType = ref.watch(selectedCuisineTypeProvider);
    final selectedPriceRange = ref.watch(selectedPriceRangeProvider);
    final priceRange = ref.watch(restaurantPriceRangeProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Filter Restaurants',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(selectedRestaurantDivisionProvider.notifier).state = null;
                    ref.read(selectedCuisineTypeProvider.notifier).state = null;
                    ref.read(selectedPriceRangeProvider.notifier).state = null;
                    ref.read(restaurantPriceRangeProvider.notifier).state = const RangeValues(500, 5000);
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          
          // Filters
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Division Filter
                  const Text(
                    'Division',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: divisions.map((division) {
                      final isSelected = selectedDivision == division;
                      return FilterChip(
                        label: Text(division),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedRestaurantDivisionProvider.notifier).state = 
                              selected ? division : null;
                        },
                        selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFF2E7D5A),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Cuisine Type Filter
                  const Text(
                    'Cuisine Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: cuisineTypes.map((cuisine) {
                      final isSelected = selectedCuisineType == cuisine;
                      return FilterChip(
                        label: Text(cuisine),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedCuisineTypeProvider.notifier).state = 
                              selected ? cuisine : null;
                        },
                        selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFF2E7D5A),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Price Range Categories
                  const Text(
                    'Price Range Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: priceRanges.map((price) {
                      final isSelected = selectedPriceRange == price;
                      return FilterChip(
                        label: Text(price),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedPriceRangeProvider.notifier).state = 
                              selected ? price : null;
                        },
                        selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFF2E7D5A),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Price Range Slider
                  const Text(
                    'Price Range (BDT for two)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: priceRange,
                    min: 500,
                    max: 5000,
                    divisions: 18,
                    labels: RangeLabels(
                      '৳${priceRange.start.toInt()}',
                      '৳${priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      ref.read(restaurantPriceRangeProvider.notifier).state = values;
                    },
                    activeColor: const Color(0xFF2E7D5A),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('৳${priceRange.start.toInt()}'),
                      Text('৳${priceRange.end.toInt()}'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D5A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantDetailScreen extends ConsumerWidget {
  final String restaurantId;
  
  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(bangladeshRestaurantsProvider);
    
    return restaurantsAsync.when(
      data: (restaurants) {
        final restaurant = restaurants.firstWhere(
          (r) => r.id == restaurantId,
          orElse: () => restaurants.first, // Fallback
        );
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () => context.go('/'),
                    tooltip: 'Go to Home',
                  ),
                  // Favorite Button
                  Consumer(
                    builder: (context, ref, child) {
                      final favoriteRestaurantIds = ref.watch(favoriteRestaurantsProvider);
                      final isFavorite = favoriteRestaurantIds.contains(restaurant.id);
                      return IconButton(
                        onPressed: () {
                          print(' Restaurant detail favorite button tapped: ${restaurant.name}, isFavorite: $isFavorite');
                          if (isFavorite) {
                            ref.read(favoriteRestaurantsProvider.notifier).state = 
                              {...favoriteRestaurantIds}..remove(restaurant.id);
                            print(' Removed restaurant from favorites: ${restaurant.id}');
                          } else {
                            ref.read(favoriteRestaurantsProvider.notifier).state = 
                              {...favoriteRestaurantIds, restaurant.id};
                            print(' Added restaurant to favorites: ${restaurant.id}');
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                      );
                    },
                  ),
                  // Budget Button
                  Consumer(
                    builder: (context, ref, child) {
                      final budgetItems = ref.watch(budgetItemsProvider);
                      final isInBudget = budgetItems.any((item) => 
                        item.type == 'restaurant' && item.id == restaurant.id);
                      return IconButton(
                        onPressed: () {
                          print(' Restaurant detail budget button tapped: ${restaurant.name}, isInBudget: $isInBudget');
                          if (isInBudget) {
                            ref.read(budgetItemsProvider.notifier).state = 
                              budgetItems.where((item) => 
                                !(item.type == 'restaurant' && item.id == restaurant.id)).toList();
                            print(' Removed restaurant from budget: ${restaurant.id}');
                          } else {
                            final newItem = BudgetItem(
                              id: restaurant.id,
                              type: 'restaurant',
                              name: restaurant.name,
                              price: restaurant.averageCostForTwo,
                              currency: '৳',
                              imageUrl: restaurant.images.first,
                              location: '${restaurant.location.city}, ${restaurant.division}',
                              quantity: 1,
                            );
                            ref.read(budgetItemsProvider.notifier).state = 
                              [...budgetItems, newItem];
                            print(' Added restaurant to budget: ${restaurant.id}');
                          }
                        },
                        icon: Icon(
                          isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                          color: isInBudget ? const Color(0xFF2E7D5A) : Colors.white,
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(restaurant.images.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Restaurant Info Overlay
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (restaurant.isHalal)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'HALAL',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getPriceRangeColor(restaurant.priceRange),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        restaurant.priceRange.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  restaurant.cuisineType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Restaurant Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating and Basic Info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${restaurant.reviewCount})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '৳${restaurant.averageCostForTwo.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D5A),
                                ),
                              ),
                              const Text(
                                'for two people',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Description
                      const Text(
                        'About',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Location Info
                      const Text(
                        'Location',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF2E7D5A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${restaurant.location.address}, ${restaurant.location.city}, ${restaurant.division}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Specialties
                      const Text(
                        'Specialties',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: restaurant.specialties.map((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF2E7D5A).withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              specialty,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7D5A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Popular Dishes
                      const Text(
                        'Popular Dishes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...restaurant.popularDishes.map((dish) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.restaurant_menu, size: 16, color: Color(0xFF2E7D5A)),
                            const SizedBox(width: 8),
                            Text(dish, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      )),
                      
                      const SizedBox(height: 20),
                      
                      // Amenities and Services
                      const Text(
                        'Services & Amenities',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          _buildServiceChip(
                            icon: Icons.delivery_dining,
                            label: 'Delivery',
                            available: restaurant.hasDelivery,
                          ),
                          const SizedBox(width: 12),
                          _buildServiceChip(
                            icon: Icons.book_online,
                            label: 'Reservations',
                            available: restaurant.hasReservation,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          _buildServiceChip(
                            icon: Icons.local_parking,
                            label: 'Parking',
                            available: restaurant.hasParking,
                          ),
                          const SizedBox(width: 12),
                          _buildServiceChip(
                            icon: Icons.credit_card,
                            label: 'Cards',
                            available: restaurant.acceptsCards,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Opening Hours
                      const Text(
                        'Hours',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            restaurant.isOpen ? Icons.access_time : Icons.access_time_filled,
                            color: restaurant.isOpen ? Colors.green : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${restaurant.openingHours} - ${restaurant.closingHours}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: restaurant.isOpen ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              restaurant.isOpen ? 'Open' : 'Closed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      if (restaurant.contactPhone != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFF2E7D5A), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              restaurant.contactPhone!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        children: [
                          // Save to Favorites Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final favoriteRestaurantIds = ref.watch(favoriteRestaurantsProvider);
                                final isFavorite = favoriteRestaurantIds.contains(restaurant.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Restaurant Save button tapped: ${restaurant.name}, isFavorite: $isFavorite');
                                    if (isFavorite) {
                                      ref.read(favoriteRestaurantsProvider.notifier).state = 
                                        {...favoriteRestaurantIds}..remove(restaurant.id);
                                      print(' Removed restaurant from favorites: ${restaurant.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from favorites')),
                                      );
                                    } else {
                                      ref.read(favoriteRestaurantsProvider.notifier).state = 
                                        {...favoriteRestaurantIds, restaurant.id};
                                      print(' Added restaurant to favorites: ${restaurant.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Saved to favorites!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey[600],
                                  ),
                                  label: Text(
                                    isFavorite ? 'Added to Favorite' : 'Add to Favorite',
                                    style: TextStyle(
                                      color: isFavorite ? Colors.red : Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFavorite ? Colors.red.withValues(alpha: 0.1) : Colors.grey[100],
                                    elevation: 0,
                                    side: BorderSide(
                                      color: isFavorite ? Colors.red : Colors.grey[300]!,
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Add to Budget Button
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final budgetItems = ref.watch(budgetItemsProvider);
                                final isInBudget = budgetItems.any((item) => 
                                  item.type == 'restaurant' && item.id == restaurant.id);
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    print(' Restaurant Budget button tapped: ${restaurant.name}, isInBudget: $isInBudget');
                                    if (isInBudget) {
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        budgetItems.where((item) => 
                                          !(item.type == 'restaurant' && item.id == restaurant.id)).toList();
                                      print(' Removed restaurant from budget: ${restaurant.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from budget')),
                                      );
                                    } else {
                                      final newItem = BudgetItem(
                                        id: restaurant.id,
                                        type: 'restaurant',
                                        name: restaurant.name,
                                        price: restaurant.averageCostForTwo,
                                        currency: '৳',
                                        imageUrl: restaurant.images.first,
                                        location: '${restaurant.location.city}, ${restaurant.division}',
                                        quantity: 1,
                                      );
                                      ref.read(budgetItemsProvider.notifier).state = 
                                        [...budgetItems, newItem];
                                      print(' Added restaurant to budget: ${restaurant.id}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to budget!')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    isInBudget ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isInBudget ? 'In Budget' : 'Add to Budget',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInBudget ? Colors.green : const Color(0xFF2E7D5A),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading restaurant: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/restaurants'),
                child: const Text('Back to Restaurants'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceChip({
    required IconData icon,
    required String label,
    required bool available,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: available 
          ? const Color(0xFF2E7D5A).withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: available 
            ? const Color(0xFF2E7D5A).withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? icon : Icons.close,
            size: 16,
            color: available ? const Color(0xFF2E7D5A) : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: available ? const Color(0xFF2E7D5A) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriceRangeColor(String priceRange) {
    switch (priceRange.toLowerCase()) {
      case 'budget':
        return Colors.green;
      case 'mid-range':
        return Colors.orange;
      case 'fine dining':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('An error occurred: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}