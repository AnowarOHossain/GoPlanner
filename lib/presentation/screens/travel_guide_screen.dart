// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import favorites provider
import '../providers/favorites_provider.dart';

// Travel guide screen showing all hotels, restaurants, and attractions
// Has 4 tabs: All Items, Hotels, Restaurants, and Attractions
// Each tab shows items with search and filter options
class TravelGuideScreen extends ConsumerStatefulWidget {
  const TravelGuideScreen({super.key});

  @override
  ConsumerState<TravelGuideScreen> createState() => _TravelGuideScreenState();
}

class _TravelGuideScreenState extends ConsumerState<TravelGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controls tab switching

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with 4 tabs
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Guide'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'AI Guide', icon: Icon(Icons.auto_awesome, size: 16)),
            Tab(text: 'Itinerary', icon: Icon(Icons.schedule, size: 16)),
            Tab(text: 'Tips', icon: Icon(Icons.lightbulb, size: 16)),
            Tab(text: 'Explore', icon: Icon(Icons.explore, size: 16)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAIGuideTab(),
          _buildItineraryTab(),
          _buildTipsTab(),
          _buildExploreTab(),
        ],
      ),
    );
  }

  Widget _buildAIGuideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Assistant Card
          _buildAIAssistantCard(),
          const SizedBox(height: 24),

          // Quick Planning Cards
          _buildQuickPlanningSection(),
          const SizedBox(height: 24),

          // Popular Destinations
          _buildPopularDestinationsSection(),
          const SizedBox(height: 24),

          // AI Recommendations
          _buildAIRecommendationsSection(),
        ],
      ),
    );
  }

  Widget _buildAIAssistantCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D5A), Color(0xFF4ADE80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'AI Travel Assistant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Get personalized travel recommendations powered by AI. Tell me your preferences and I\'ll create the perfect itinerary for you!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAIDialog(context),
                icon: const Icon(Icons.chat, color: Color(0xFF2E7D5A)),
                label: const Text(
                  'Start Planning',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D5A),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPlanningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Planning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickPlanCard(
                'Day Trip',
                'Perfect for a single day adventure',
                Icons.today,
                Colors.blue,
                () => _showPlanDialog(context, 'Day Trip'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickPlanCard(
                'Weekend',
                'Great for 2-3 day getaways',
                Icons.weekend,
                Colors.purple,
                () => _showPlanDialog(context, 'Weekend'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickPlanCard(
                'Week Long',
                'Comprehensive 7-day exploration',
                Icons.date_range,
                Colors.orange,
                () => _showPlanDialog(context, 'Week Long'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickPlanCard(
                'Custom',
                'Create your own timeline',
                Icons.settings,
                Colors.green,
                () => _showCustomPlanDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickPlanCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItineraryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create New Itinerary
          _buildCreateItineraryCard(),
          const SizedBox(height: 24),

          // Saved Itineraries
          _buildSavedItinerariesSection(),
          const SizedBox(height: 24),

          // Sample Itineraries
          _buildSampleItinerariesSection(),
        ],
      ),
    );
  }

  Widget _buildCreateItineraryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.add_circle,
                  color: Color(0xFF2E7D5A),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Create New Itinerary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Plan your perfect trip with our AI-powered itinerary generator. Just tell us your preferences!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showItineraryCreator(context),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Itinerary'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D5A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItinerariesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved Itineraries',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'No Saved Itineraries',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create your first itinerary to see it here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSampleItinerariesSection() {
    final sampleItineraries = [
      {
        'title': '3 Days in Dhaka',
        'duration': '3 Days',
        'type': 'Cultural',
        'description': 'Explore the bustling capital with its rich history and vibrant culture',
        'highlights': ['Old Dhaka', 'Lalbagh Fort', 'Ahsan Manzil', 'National Museum'],
      },
      {
        'title': 'Cox\'s Bazar Beach Holiday',
        'duration': '5 Days',
        'type': 'Beach',
        'description': 'Relax on the world\'s longest natural sea beach',
        'highlights': ['Beach Activities', 'Himchari', 'Inani Beach', 'Local Seafood'],
      },
      {
        'title': 'Sylhet Tea Country',
        'duration': '4 Days',
        'type': 'Nature',
        'description': 'Discover tea gardens and natural beauty of Sylhet division',
        'highlights': ['Srimangal', 'Lawachara Park', 'Tea Gardens', 'Waterfalls'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sample Itineraries',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...sampleItineraries.map((itinerary) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () => _showSampleItinerary(context, itinerary),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              itinerary['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              itinerary['duration'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7D5A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        itinerary['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (itinerary['highlights'] as List<String>).take(3).map((highlight) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              highlight,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAIRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          'Cultural Heritage Explorer',
          'Discover Bangladesh\'s rich history and cultural landmarks',
          Icons.museum,
          Colors.purple,
          ['Lalbagh Fort', 'Ahsan Manzil', 'Paharpur', 'Mainamati'],
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          'Nature & Adventure',
          'Experience the natural beauty and wildlife of Bangladesh',
          Icons.nature,
          Colors.green,
          ['Sundarbans', 'Lawachara', 'Rangamati', 'Bandarban'],
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          'Food & Culture Tour',
          'Taste authentic Bengali cuisine and local delicacies',
          Icons.restaurant,
          Colors.orange,
          ['Old Dhaka Food Tour', 'Chittagong Seafood', 'Sylhet Tea Culture'],
        ),
      ],
    );
  }

  Widget _buildPopularDestinationsSection() {
    final popularDestinations = [
      {
        'name': 'Cox\'s Bazar',
        'type': 'Beach Paradise',
        'image': '',
        'rating': 4.8,
        'description': 'World\'s longest natural sea beach'
      },
      {
        'name': 'Sundarbans',
        'type': 'Mangrove Forest',
        'image': '',
        'rating': 4.6,
        'description': 'UNESCO World Heritage Site'
      },
      {
        'name': 'Srimangal',
        'type': 'Tea Gardens',
        'image': '',
        'rating': 4.7,
        'description': 'Tea capital of Bangladesh'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/attractions'),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularDestinations.length,
            itemBuilder: (context, index) {
              final destination = popularDestinations[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  right: index < popularDestinations.length - 1 ? 12 : 0,
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _showDestinationDetails(context, destination),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              destination['image'] as String,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            destination['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            destination['type'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${destination['rating']}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            destination['description'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    String title,
    String description,
    IconData icon,
    Color color,
    List<String> highlights,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () => Navigator.pushNamed(context, '/attractions'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: highlights.take(3).map((highlight) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    highlight,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Methods
  void _showAIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF2E7D5A)),
            SizedBox(width: 8),
            Text('AI Travel Assistant'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tell me about your travel preferences:'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., I want a 3-day cultural trip in Dhaka...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI planning feature coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Generate Plan'),
          ),
        ],
      ),
    );
  }

  void _showPlanDialog(BuildContext context, String planType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$planType Planning'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create a $planType itinerary'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Starting Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Preferred Activities',
                border: OutlineInputBorder(),
              ),
            ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$planType plan created!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCustomPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Planning'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Trip Duration (days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Budget Range',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Travel Style',
                border: OutlineInputBorder(),
              ),
            ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Custom plan created!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showItineraryCreator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Itinerary'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Duration (days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Travel Style',
                border: OutlineInputBorder(),
              ),
            ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Itinerary creation feature coming soon!')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showSampleItinerary(BuildContext context, Map<String, dynamic> itinerary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(itinerary['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${itinerary['duration']} • ${itinerary['type']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(itinerary['description'] as String),
            const SizedBox(height: 16),
            const Text('Highlights:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...(itinerary['highlights'] as List<String>).map((highlight) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D5A)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(highlight)),
                  ],
                ),
              )
            ).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Itinerary customization coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Use Template'),
          ),
        ],
      ),
    );
  }




  Widget _buildTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Essential Tips
          _buildEssentialTipsSection(),
          const SizedBox(height: 24),

          // Category Tips
          _buildCategoryTipsSection(),
          const SizedBox(height: 24),

          // Local Insights
          _buildLocalInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildEssentialTipsSection() {
    final essentialTips = [
      {
        'title': 'Best Time to Visit',
        'content': 'October to March offers the most pleasant weather for traveling across Bangladesh.',
        'icon': Icons.calendar_today,
        'color': Colors.blue,
      },
      {
        'title': 'Currency & Payment',
        'content': 'Bangladeshi Taka (BDT) is the local currency. Credit cards accepted in major hotels and restaurants.',
        'icon': Icons.account_balance_wallet,
        'color': Colors.green,
      },
      {
        'title': 'Transportation',
        'content': 'Rickshaws, CNGs, buses, and trains are common. Uber and ride-sharing apps available in major cities.',
        'icon': Icons.directions_bus,
        'color': Colors.orange,
      },
      {
        'title': 'Language',
        'content': 'Bengali is the official language. English is widely understood in tourist areas.',
        'icon': Icons.language,
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Essential Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...essentialTips.map((tip) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      tip['icon'] as IconData,
                      color: tip['color'] as Color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tip['content'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCategoryTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryTipCard(
                'Budget Travel',
                'Tips for traveling on a budget',
                Icons.savings,
                Colors.green,
                () => _showCategoryTips(context, 'Budget Travel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryTipCard(
                'Safety',
                'Stay safe while traveling',
                Icons.security,
                Colors.red,
                () => _showCategoryTips(context, 'Safety'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryTipCard(
                'Food & Health',
                'What to eat and health tips',
                Icons.health_and_safety,
                Colors.orange,
                () => _showCategoryTips(context, 'Food & Health'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryTipCard(
                'Culture',
                'Cultural norms and etiquette',
                Icons.groups,
                Colors.purple,
                () => _showCategoryTips(context, 'Culture'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTipCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocalInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Local Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Did You Know?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInsightItem('', 'Cox\'s Bazar is the world\'s longest natural sea beach at 120 km'),
                _buildInsightItem('', 'Sundarbans is home to the largest population of Bengal tigers'),
                _buildInsightItem('', 'Bangladesh produces 2% of world\'s tea, mostly from Sylhet region'),
                _buildInsightItem('', 'Paharpur Buddhist Monastery is one of the largest in South Asia'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    final favoriteHotels = ref.watch(favoriteHotelsProvider);
    final favoriteRestaurants = ref.watch(favoriteRestaurantsProvider);
    final favoriteAttractions = ref.watch(favoriteAttractionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Explore Categories
          _buildExploreCategoriesSection(),
          const SizedBox(height: 24),

          // Your Favorites
          _buildYourFavoritesSection(favoriteHotels, favoriteRestaurants, favoriteAttractions),
          const SizedBox(height: 24),

          // Trending Places
          _buildTrendingPlacesSection(),
        ],
      ),
    );
  }

  Widget _buildExploreCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore by Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildExploreCard('Hotels', Icons.hotel, Colors.blue, '/hotels'),
            _buildExploreCard('Restaurants', Icons.restaurant, Colors.orange, '/restaurants'),
            _buildExploreCard('Attractions', Icons.place, Colors.green, '/attractions'),
            _buildExploreCard('Budget', Icons.account_balance_wallet, Colors.purple, '/cart'),
          ],
        ),
      ],
    );
  }

  Widget _buildExploreCard(String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourFavoritesSection(
    Set<String> favoriteHotels,
    Set<String> favoriteRestaurants,
    Set<String> favoriteAttractions,
  ) {
    final totalFavorites = favoriteHotels.length + favoriteRestaurants.length + favoriteAttractions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Your Favorites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (totalFavorites > 0)
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/favorites'),
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: totalFavorites > 0
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFavoriteCount('Hotels', favoriteHotels.length, Icons.hotel),
                          _buildFavoriteCount('Restaurants', favoriteRestaurants.length, Icons.restaurant),
                          _buildFavoriteCount('Attractions', favoriteAttractions.length, Icons.place),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start exploring and save your favorite places!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCount(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF2E7D5A)),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingPlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Places',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTrendingItem('1', 'Cox\'s Bazar Sea Beach', 'Most visited destination'),
                _buildTrendingItem('2', 'Sundarbans Mangrove Forest', 'UNESCO World Heritage Site'),
                _buildTrendingItem('3', 'Srimangal Tea Gardens', 'Tea capital of Bangladesh'),
                _buildTrendingItem('4', 'Rangamati Lake', 'Beautiful hill district'),
                _buildTrendingItem('5', 'Kuakata Sea Beach', 'Panoramic sea beach'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingItem(String rank, String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF2E7D5A),
            child: Text(
              rank,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.trending_up, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  void _showDestinationDetails(BuildContext context, Map<String, dynamic> destination) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(destination['name'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination['type'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${destination['rating']} rating'),
                ],
              ),
              const SizedBox(height: 8),
              Text(destination['description'] as String),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Explore'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/attractions');
              },
            ),
          ],
        );
      },
    );
  }

  void _showCategoryTips(BuildContext context, String category) {
    final tips = {
      'Budget Travel': [
        'Stay in budget hotels or guesthouses',
        'Use local transportation like buses and rickshaws',
        'Eat at local restaurants for authentic and cheap food',
        'Book accommodations in advance for better rates',
      ],
      'Safety': [
        'Keep copies of important documents',
        'Avoid displaying valuable items',
        'Use registered transportation',
        'Stay aware of your surroundings',
      ],
      'Food & Health': [
        'Try local Bengali cuisine but start slowly',
        'Drink bottled or purified water',
        'Carry basic medications',
        'Wash hands frequently',
      ],
      'Culture': [
        'Dress modestly, especially in rural areas',
        'Remove shoes when entering mosques or homes',
        'Learn basic Bengali greetings',
        'Respect local customs and traditions',
      ],
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$category Tips'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...tips[category]!.map((tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}