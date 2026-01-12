// ignore_for_file: deprecated_member_use
// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import GoRouter for navigation
import 'package:go_router/go_router.dart';
// Import listings provider for favorites and budget
import '../providers/listings_provider.dart';
import '../providers/auth_providers.dart';
import '../providers/user_preferences_provider.dart';
import '../../core/services/trip_suggestion_service.dart';

// Profile screen showing user's favorites, budget, and settings
// This is the main profile page with tabs for different sections
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? tripPlan;
  bool isLoadingTripPlan = false;

  Future<void> _loadTripPlan(String city, double budget) async {
    setState(() {
      isLoadingTripPlan = true;
    });
    tripPlan = await TripSuggestionService.getTripPlan(city: city, budget: budget);
    setState(() {
      isLoadingTripPlan = false;
    });
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          ElevatedButton(
            onPressed: () async {
              await _loadTripPlan('Dhaka', 20000); // Example usage
            },
            child: const Text('Suggest a weekend trip for Dhaka'),
          ),
          if (isLoadingTripPlan)
            const Center(child: CircularProgressIndicator()),
          if (tripPlan != null)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    tripPlan!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    
    // Get display name, or extract name from email, or use default
    String displayName = 'Hello, Traveler!';
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        displayName = user.displayName!;
      } else if (user.email != null) {
        // Extract name from email (e.g., "anowar@gmail.com" -> "Anowar")
        final emailName = user.email!.split('@').first;
        // Capitalize first letter
        displayName = emailName[0].toUpperCase() + emailName.substring(1);
      }
    }

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
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user == null ? 'Your next adventure awaits!' : 'Welcome back!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user?.email != null)
                    Text(
                      user!.email!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.explore,
                          size: 16,
                          color: const Color(0xFF2E7D5A),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Unlock personalized trip plans',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: user == null
                        ? ElevatedButton.icon(
                            onPressed: () {
                              final from = Uri.encodeComponent(GoRouterState.of(context).uri.toString());
                              context.go('/login?from=$from');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.rocket_launch, size: 18),
                            label: const Text('Start Your Journey'),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              await ref.read(authServiceProvider).signOut();
                            },
                            child: const Text('Logout'),
                          ),
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
    final prefs = ref.watch(userPreferencesProvider);
    
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPreferenceItem('Budget Level', prefs.budgetLevelDisplay, Icons.attach_money),
            _buildPreferenceItem('Adventure Level', prefs.adventureLevelDisplay, Icons.landscape),
            _buildPreferenceItem('Travel Pace', prefs.travelPaceDisplay, Icons.schedule),
            _buildPreferenceItem('Group Size', prefs.groupSizeDisplay, Icons.group),
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

// Full settings screen with functional preferences using Riverpod
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);
    final prefsNotifier = ref.read(userPreferencesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
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
            'App Preferences',
            [
              // Dark Mode Toggle
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: Color(0xFF2E7D5A)),
                title: const Text('Dark Mode'),
                subtitle: Text(prefs.darkModeEnabled ? 'Enabled' : 'Disabled'),
                value: prefs.darkModeEnabled,
                onChanged: (value) => prefsNotifier.setDarkModeEnabled(value),
              ),
              // Notifications Toggle
              SwitchListTile(
                secondary: const Icon(Icons.notifications, color: Color(0xFF2E7D5A)),
                title: const Text('Notifications'),
                subtitle: Text(prefs.notificationsEnabled ? 'Enabled' : 'Disabled'),
                value: prefs.notificationsEnabled,
                onChanged: (value) => prefsNotifier.setNotificationsEnabled(value),
              ),
              // Location Toggle
              SwitchListTile(
                secondary: const Icon(Icons.location_on, color: Color(0xFF2E7D5A)),
                title: const Text('Location Services'),
                subtitle: Text(prefs.locationEnabled ? 'Enabled' : 'Disabled'),
                value: prefs.locationEnabled,
                onChanged: (value) => prefsNotifier.setLocationEnabled(value),
              ),
              // Language Selection
              _buildSettingsTile(
                'Language',
                prefs.languageDisplay,
                Icons.language,
                () => _showLanguageSelector(context, ref, prefs.preferredLanguage),
              ),
              // Currency Selection
              _buildSettingsTile(
                'Currency',
                prefs.currencyDisplay,
                Icons.attach_money,
                () => _showCurrencySelector(context, ref, prefs.preferredCurrency),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'Travel Preferences',
            [
              // Budget Level
              _buildSettingsTile(
                'Budget Level',
                prefs.budgetLevelDisplay,
                Icons.account_balance_wallet,
                () => _showBudgetSelector(context, ref, prefs.budgetLevel),
              ),
              // Adventure Level
              _buildSettingsTile(
                'Adventure Level',
                prefs.adventureLevelDisplay,
                Icons.landscape,
                () => _showAdventureSelector(context, ref, prefs.adventureLevel),
              ),
              // Travel Pace
              _buildSettingsTile(
                'Travel Pace',
                prefs.travelPaceDisplay,
                Icons.schedule,
                () => _showTravelPaceSelector(context, ref, prefs.travelPace),
              ),
              // Group Size
              _buildSettingsTile(
                'Group Size',
                prefs.groupSizeDisplay,
                Icons.group,
                () => _showGroupSizeSelector(context, ref, prefs.groupSize),
              ),
              // Interests
              _buildSettingsTile(
                'Interests',
                prefs.interests.isEmpty ? 'None selected' : prefs.interests.join(', '),
                Icons.interests,
                () => _showInterestsSelector(context, ref, prefs.interests),
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

  void _showLanguageSelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Language',
        [
          _OptionItem('en', 'English'),
          _OptionItem('bn', 'বাংলা (Bengali)'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setLanguage(value),
      ),
    );
  }

  void _showCurrencySelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Currency',
        [
          _OptionItem('BDT', 'BDT (৳) - Bangladeshi Taka'),
          _OptionItem('USD', 'USD (\$) - US Dollar'),
          _OptionItem('EUR', 'EUR (€) - Euro'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setCurrency(value),
      ),
    );
  }

  void _showBudgetSelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Budget Level',
        [
          _OptionItem('budget', 'Budget'),
          _OptionItem('mid-range', 'Mid-range'),
          _OptionItem('luxury', 'Luxury'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setBudgetLevel(value),
      ),
    );
  }

  void _showAdventureSelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Adventure Level',
        [
          _OptionItem('low', 'Low - Prefer relaxed activities'),
          _OptionItem('moderate', 'Moderate - Mix of activities'),
          _OptionItem('high', 'High - Love adventure!'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setAdventureLevel(value),
      ),
    );
  }

  void _showTravelPaceSelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Travel Pace',
        [
          _OptionItem('relaxed', 'Relaxed - Take it easy'),
          _OptionItem('moderate', 'Moderate - Balanced'),
          _OptionItem('fast', 'Fast-paced - See everything!'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setTravelPace(value),
      ),
    );
  }

  void _showGroupSizeSelector(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionSelector(
        context,
        'Select Group Size',
        [
          _OptionItem('solo', 'Solo'),
          _OptionItem('couple', 'Couple'),
          _OptionItem('small-group', 'Small Group (3-6)'),
          _OptionItem('large-group', 'Large Group (7+)'),
        ],
        current,
        (value) => ref.read(userPreferencesProvider.notifier).setGroupSize(value),
      ),
    );
  }

  void _showInterestsSelector(BuildContext context, WidgetRef ref, List<String> currentInterests) {
    final allInterests = ['nature', 'history', 'food', 'adventure', 'culture', 'photography', 'wildlife', 'beaches'];
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Your Interests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allInterests.map((interest) {
                    final isSelected = currentInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest[0].toUpperCase() + interest.substring(1)),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(userPreferencesProvider.notifier).toggleInterest(interest);
                        // Use mounted check and show selector after pop
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            _showInterestsSelector(context, ref, ref.read(userPreferencesProvider).interests);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF2E7D5A).withValues(alpha: 0.3),
                      checkmarkColor: const Color(0xFF2E7D5A),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D5A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionSelector(
    BuildContext context,
    String title,
    List<_OptionItem> options,
    String currentValue,
    Function(String) onSelect,
  ) {
    // Use standard Radio widgets for compatibility with Flutter stable
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => ListTile(
            title: Text(option.label),
            leading: Radio<String>(
              value: option.value,
              groupValue: currentValue,
              onChanged: (value) {
                if (value != null) {
                  onSelect(value);
                  Navigator.pop(context);
                }
              },
              activeColor: const Color(0xFF2E7D5A),
            ),
            onTap: () {
              onSelect(option.value);
              Navigator.pop(context);
            },
          )),
        ],
      ),
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

// Helper class for option items in selectors
class _OptionItem {
  final String value;
  final String label;
  
  _OptionItem(this.value, this.label);
}