# GoPlanner - AI-Powered Travel Planning App

A comprehensive Flutter mobile application for travel planning with smart travel guide, budget management, and location services.

## ✨ Features

- **Browse & Discover**: Hotels, restaurants, and attractions with images, ratings, and pricing
- **Smart Budget Management**: Add items to cart and calculate total trip costs with detailed breakdowns
- **Smart Travel Guide**: Get personalized travel recommendations and planning assistance (Coming Soon)
- **Advanced Search & Filters**: Filter by category, price range, ratings, location, and more
- **Favorites & Save**: Save favorite places across hotels, restaurants, and attractions
- **Interactive Maps**: Google Maps integration for location display and navigation
- **User Profile**: Track your travel stats, manage favorites, and quick access to features
- **Responsive Navigation**: Smart back button handling and intuitive routing
- **Multi-Tab Experience**: Organized favorites viewing with separate tabs for each category

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Routing**: GoRouter for declarative routing
- **Backend**: Firebase Firestore + Local JSON
- **AI Integration**: Google Gemini API (Ready for integration)
- **Maps**: Google Maps Flutter Plugin with Location Services
- **Authentication**: Firebase Auth (Ready for integration)
- **Data Storage**: JSON-based local data with provider caching

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or later
- Dart SDK 3.2.0 or later
- Android Studio or VS Code with Flutter extension
- Firebase account
- Google Cloud Console account (for Maps & Gemini API)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/AnowarOHossain/GoPlanner.git
cd GoPlanner
```

2. **Install dependencies**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

3. **Check setup**
```bash
flutter doctor
```

## 🆕 Recent Updates

### ✅ Latest Improvements (October 2025)
- **Fixed duplicate buttons**: Removed redundant "Add to Favorite" and "Add to Budget" buttons
- **Enhanced Profile functionality**: Made travel stats clickable with proper navigation
- **Improved button styling**: Consistent text formatting across all screens
- **Fixed navigation issues**: Proper GoRouter implementation for all actions
- **Enhanced user experience**: Interactive elements throughout the app

### 🚀 App Status
- **Fully functional** for local development and testing
- **60+ items** of real Bangladesh tourism data
- **Complete user flows** from browsing to budget management
- **Ready for API integration** (Maps, AI, Firebase)
- **Production-ready UI** with consistent design system

## 🔑 API Configuration

#### Google Gemini API Key
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key for Gemini
3. Update `lib/core/constants/app_constants.dart`:
```dart
static const String geminiApiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
```

#### Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android and iOS
3. Create API key with appropriate restrictions
4. Update `lib/core/constants/app_constants.dart`:
```dart
static const String googleMapsApiKey = 'YOUR_ACTUAL_GOOGLE_MAPS_KEY';
```

### 🔥 Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "GoPlanner"
3. Enable Firestore Database
4. Add Android/iOS apps to your Firebase project
5. Download and place configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

### ▶️ Run the App
```bash
flutter run
```

## 📂 Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── constants/        # App constants, colors, strings
│   ├── utils/           # Helper functions, extensions
│   ├── services/        # API services, local storage
│   └── exceptions/      # Custom exceptions
├── data/                # Data layer
│   ├── models/          # Data models (Hotel, Restaurant, Attraction)
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Local JSON data sources
├── presentation/        # UI layer
│   ├── screens/         # App screens (Hotels, Restaurants, Attractions, Profile, Maps)
│   ├── widgets/         # Reusable widgets (ImageLoader, Filters)
│   ├── providers/       # Riverpod providers (State management)
│   ├── routes/          # GoRouter configuration and navigation
│   └── theme/           # App theme & styling
├── assets/              # Static assets
│   └── data/           # JSON data files (20 hotels, 20 restaurants, 20 attractions)
└── main.dart           # App entry point
```

## 🎯 Development Progress

### Phase 1: Project Setup ✅ COMPLETED
- [x] Create Flutter project structure
- [x] Set up dependencies and configuration
- [x] Create data models with JSON serialization
- [x] Set up Riverpod state management
- [x] Configure routing with GoRouter

### Phase 2: UI Implementation ✅ COMPLETED
- [x] Create reusable widgets and components
- [x] Build listing screens (hotels, restaurants, attractions)
- [x] Implement search and filter functionality
- [x] Create detail screens for each item type
- [x] Implement responsive navigation system

### Phase 3: Core Features ✅ COMPLETED
- [x] Cart and budget management system with breakdown
- [x] Favorites functionality across all categories
- [x] User profile with travel statistics
- [x] Interactive travel stats and navigation
- [x] Multi-tab favorites organization

### Phase 4: Maps & Location ✅ COMPLETED
- [x] Google Maps integration setup
- [x] Location services implementation
- [x] Maps screen with tabbed interface
- [x] Location permissions handling

### Phase 5: Current Status
- [x] 20 Hotels with detailed information
- [x] 20 Restaurants with cuisine and pricing
- [x] 20 Attractions with categories and activities
- [x] Fully functional add to favorites
- [x] Complete budget analysis system
- [x] Working profile management

### Phase 6: Ready for Integration
- [ ] Google Gemini API for AI itineraries
- [ ] Firebase Firestore data migration
- [ ] Real-time data synchronization
- [ ] User authentication system

### Phase 7: Polish & Deploy
- [ ] Performance optimization
- [ ] Testing and quality assurance
- [ ] App store preparation
- [ ] Release builds

## 💻 Current Features Implemented

### ✅ Fully Functional Screens
- **Home Screen**: Quick actions and feature overview
- **Hotels Screen**: 20 hotels with search, filters, and detail pages
- **Restaurants Screen**: 20 restaurants with cuisine filters and detail pages  
- **Attractions Screen**: 20 attractions with category filters and detail pages
- **Profile Screen**: Travel statistics, favorites management, quick actions
- **Maps Screen**: Google Maps integration with location services
- **Budget Analysis**: Complete cart and expense tracking
- **Favorites Screen**: Multi-tab organization for saved items

### ✅ Key Functionalities
- **Navigation**: Custom back button handling with GoRouter
- **State Management**: Riverpod providers for all app state
- **Data Management**: JSON-based local data with 60 total items
- **Search & Filter**: Advanced filtering by multiple criteria
- **Favorites System**: Add/remove favorites across all categories
- **Budget Tracking**: Add items to cart with quantity and cost analysis
- **Interactive UI**: Clickable stats, smooth navigation, consistent styling

### 🔧 Ready for Integration
- **Google Maps**: Setup complete, ready for API key
- **Location Services**: Permission handling implemented
- **Firebase**: Project structure ready for Firestore integration
- **AI Features**: Gemini API integration prepared

## � Development Commands

```bash
# Generate code files
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Build release
flutter build apk --release
flutter build ios --release
```

## 📱 App Screenshots & Features

### 🏨 Hotels Section
- Browse 20+ hotels across Bangladesh
- Filter by division, type, and price range
- Detailed hotel information with amenities
- Add to favorites and budget tracking

### 🍽️ Restaurants Section  
- Discover 20+ restaurants with diverse cuisines
- Filter by cuisine type, price range, and division
- View specialties, popular dishes, and services
- Halal certification indicators

### 🏛️ Attractions Section
- Explore 20+ tourist attractions
- Filter by category (Historical, Natural, Religious, Archaeological)
- Detailed descriptions with activities and facilities
- Entry fee information and best visiting times

### 👤 Profile & Management
- Personal travel statistics dashboard
- Favorites management across all categories
- Budget analysis with expense breakdown
- Quick access to all features

## 🧪 Testing

### Unit Tests
- Test data models
- Test utility functions
- Test provider logic

### Widget Tests
- Test individual widgets
- Test user interactions
- Test state changes

### Integration Tests
- Test complete user flows
- Test API integrations
- Test navigation

## 📦 Deployment

### Before Release
- [ ] Update app version in pubspec.yaml
- [ ] Test on physical devices
- [ ] Verify all API keys are configured
- [ ] Test offline functionality
- [ ] Check app permissions
- [ ] Optimize app size
- [ ] Generate signed builds
- [ ] Test all navigation flows
- [ ] Verify favorites and budget functionality
- [ ] Test maps and location services

### Android Release
- [ ] Generate signed APK/AAB
- [ ] Test on multiple Android versions
- [ ] Upload to Google Play Console
- [ ] Configure store listing

### iOS Release
- [ ] Generate signed IPA
- [ ] Test on multiple iOS versions
- [ ] Upload to App Store Connect
- [ ] Configure store listing

## 🔍 Troubleshooting

### Common Issues
- **Build failures**: Run `flutter clean && flutter pub get`
- **Code generation**: Run `dart run build_runner build`
- **State not updating**: Check provider dependencies
- **API errors**: Verify API keys and network connectivity

### Debug Tools
- Flutter Inspector for UI debugging
- Riverpod Inspector for state debugging
- Network inspector for API calls
- Performance overlay for optimization

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Google Gemini API](https://ai.google.dev/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)

## 📄 License

This project is licensed under the MIT License.