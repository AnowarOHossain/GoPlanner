class AppConstants {
  // App Info
  static const String appName = 'GoPlanner';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Travel Planning App';

  // API Configuration
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  
  // Firebase Collections
  static const String hotelsCollection = 'hotels';
  static const String restaurantsCollection = 'restaurants';
  static const String attractionsCollection = 'attractions';
  static const String usersCollection = 'users';
  static const String itinerariesCollection = 'itineraries';
  static const String favoritesCollection = 'favorites';

  // Local Storage Keys
  static const String userPrefsBox = 'user_preferences';
  static const String favoritesBox = 'favorites';
  static const String cartBox = 'cart_items';
  static const String itinerariesBox = 'saved_itineraries';

  // API Endpoints
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  
  // App Limits
  static const int maxCartItems = 50;
  static const int maxFavorites = 100;
  static const int maxItineraryDays = 30;
  static const double maxBudget = 100000.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;
  
  // Grid Configuration
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  static const double gridSpacing = 16.0;
}