// This file stores all constant values used throughout the app
// Using constants makes it easy to change values in one place
class AppConstants {
  // App Information
  static const String appName = 'GoPlanner';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Travel Planning App';

  // API Keys for external services
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE'; // Google AI for travel suggestions
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE'; // Google Maps
  
  // Firebase collection names (database tables)
  static const String hotelsCollection = 'hotels';
  static const String restaurantsCollection = 'restaurants';
  static const String attractionsCollection = 'attractions';
  static const String usersCollection = 'users';
  static const String itinerariesCollection = 'itineraries';
  static const String favoritesCollection = 'favorites';

  // Local storage keys for saving data on device
  static const String userPrefsBox = 'user_preferences';
  static const String favoritesBox = 'favorites';
  static const String cartBox = 'cart_items';
  static const String itinerariesBox = 'saved_itineraries';

  // API URL for Gemini AI
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  
  // App limits to prevent too much data
  static const int maxCartItems = 50; // Maximum items in budget planner
  static const int maxFavorites = 100; // Maximum favorite items
  static const int maxItineraryDays = 30; // Maximum days for trip
  static const double maxBudget = 100000.0; // Maximum budget in taka

  // Animation speeds for smooth transitions
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI spacing values for consistent design
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0; // Corner roundness
  static const double cardRadius = 16.0;
  
  // Grid layout configuration
  static const int gridCrossAxisCount = 2; // 2 columns in grid
  static const double gridChildAspectRatio = 0.75; // Card width/height ratio
  static const double gridSpacing = 16.0; // Space between grid items
}