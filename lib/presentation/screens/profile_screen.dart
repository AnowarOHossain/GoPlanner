// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import listings provider for favorites and budget
import '../providers/listings_provider.dart';

// Profile screen showing user's favorites, budget, and settings
// This is the main profile page with tabs for different sections
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Get all favorite items from providers
    final favoriteHotels = ref.watch(favoriteHotelsProvider);
    final favoriteRestaurants = ref.watch(favoriteRestaurantsProvider);
    final favoriteAttractions = ref.watch(favoriteAttractionsProvider);
    // Get budget items
    final budgetItems = ref.watch(budgetItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            _buildUserInfoCard(context),
            const SizedBox(height: 24),

            // Statistics Cards
            _buildStatisticsSection(
              favoriteHotels.length,
              favoriteRestaurants.length,
              favoriteAttractions.length,
              budgetItems.length,
            ),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActionsSection(context),
            const SizedBox(height: 24),

            // Favorites Summary
            _buildFavoritesSummary(context),
            const SizedBox(height: 24),

            // Travel Preferences
            _buildTravelPreferences(context),
            const SizedBox(height: 24),

            // Recent Activity
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF2E7D5A),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Travel Explorer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bangladesh Travel Enthusiast',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Dhaka, Bangladesh',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
  }

  Widget _buildStatisticsSection(
    int hotelCount,
    int restaurantCount,
    int attractionCount,
    int budgetItemCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Travel Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Favorite Hotels',
                hotelCount.toString(),
                Icons.hotel,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Restaurants',
                restaurantCount.toString(),
                Icons.restaurant,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Attractions',
                attractionCount.toString(),
                Icons.place,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Budget Items',
                budgetItemCount.toString(),
                Icons.account_balance_wallet,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return InkWell(
      onTap: () => _handleStatCardTap(title),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
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

  void _handleStatCardTap(String title) {
    switch (title) {
      case 'Favorite Hotels':
        context.go('/favorites');
        break;
      case 'Restaurants':
        context.go('/favorites');
        break;
      case 'Attractions':
        context.go('/favorites');
        break;
      case 'Budget Items':
        context.go('/cart');
        break;
    }
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildActionTile(
              'View Favorites',
              'See all your saved places',
              Icons.favorite,
              Colors.red,
              () => context.go('/favorites'),
            ),
            _buildActionTile(
              'Manage Budget',
              'Track your travel expenses',
              Icons.account_balance_wallet,
              Colors.green,
              () => context.go('/cart'),
            ),
            _buildActionTile(
              'Travel History',
              'View your past trips',
              Icons.history,
              Colors.blue,
              () => _showComingSoonDialog(context, 'Travel History'),
            ),
            _buildActionTile(
              'Share App',
              'Tell friends about GoPlanner',
              Icons.share,
              Colors.purple,
              () => _showShareDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFavoritesSummary(BuildContext context) {
    final favoriteHotels = ref.watch(favoriteHotelsProvider);
    final favoriteRestaurants = ref.watch(favoriteRestaurantsProvider);
    final favoriteAttractions = ref.watch(favoriteAttractionsProvider);

    final totalFavorites = favoriteHotels.length + 
                          favoriteRestaurants.length + 
                          favoriteAttractions.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Favorites Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$totalFavorites items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (totalFavorites > 0) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFavoriteCount('Hotels', favoriteHotels.length, Icons.hotel),
                  _buildFavoriteCount('Restaurants', favoriteRestaurants.length, Icons.restaurant),
                  _buildFavoriteCount('Attractions', favoriteAttractions.length, Icons.place),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                'Start exploring and save your favorite places!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCount(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2E7D5A)),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
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

  Widget _buildTravelPreferences(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, color: Color(0xFF2E7D5A)),
                const SizedBox(width: 8),
                const Text(
                  'Travel Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showComingSoonDialog(context, 'Preferences Settings'),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPreferenceItem('Budget Level', 'Mid-range', Icons.attach_money),
            _buildPreferenceItem('Adventure Level', 'Moderate', Icons.landscape),
            _buildPreferenceItem('Travel Pace', 'Relaxed', Icons.schedule),
            _buildPreferenceItem('Group Size', 'Small Group', Icons.group),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: Color(0xFF2E7D5A)),
                const SizedBox(width: 8),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Added to favorites',
              'Cox\'s Bazar Sea Beach',
              Icons.favorite,
              '2 hours ago',
            ),
            _buildActivityItem(
              'Added to budget',
              'Dhaka Regency Hotel',
              Icons.add_shopping_cart,
              '1 day ago',
            ),
            _buildActivityItem(
              'Viewed details',
              'Sundarbans National Park',
              Icons.visibility,
              '2 days ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String action, String item, IconData icon, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF2E7D5A).withValues(alpha: 0.1),
            child: Icon(icon, size: 16, color: const Color(0xFF2E7D5A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature is coming soon! Stay tuned for updates.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share GoPlanner'),
          content: const Text(
            'Help your friends discover amazing places in Bangladesh with GoPlanner - the ultimate travel planning app!',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Share'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share feature coming soon!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(
            'Account',
            [
              _buildSettingsTile(
                'Edit Profile',
                'Update your personal information',
                Icons.person,
                () => _showComingSoon(context, 'Edit Profile'),
              ),
              _buildSettingsTile(
                'Privacy',
                'Manage your privacy settings',
                Icons.privacy_tip,
                () => _showComingSoon(context, 'Privacy Settings'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'Preferences',
            [
              _buildSettingsTile(
                'Notifications',
                'Manage notification preferences',
                Icons.notifications,
                () => _showComingSoon(context, 'Notification Settings'),
              ),
              _buildSettingsTile(
                'Language',
                'Change app language',
                Icons.language,
                () => _showComingSoon(context, 'Language Settings'),
              ),
              _buildSettingsTile(
                'Currency',
                'Set preferred currency',
                Icons.attach_money,
                () => _showComingSoon(context, 'Currency Settings'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'Support',
            [
              _buildSettingsTile(
                'Help & Support',
                'Get help and contact support',
                Icons.help,
                () => _showComingSoon(context, 'Help & Support'),
              ),
              _buildSettingsTile(
                'About',
                'App version and information',
                Icons.info,
                () => _showAboutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D5A),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2E7D5A)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature is coming soon! We\'re working hard to bring you this feature.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About GoPlanner'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: 1.0.0'),
              SizedBox(height: 8),
              Text('GoPlanner is your ultimate travel companion for exploring Bangladesh.'),
              SizedBox(height: 8),
              Text('Discover amazing places, plan your itinerary, and manage your travel budget all in one app.'),
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