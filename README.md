# GoPlanner - AI-Powered Travel Planning App

A comprehensive Flutter mobile application for travel planning with smart travel guide, budget management, and location services.

## ✨ Features

- **Browse & Discover**: Hotels, restaurants, and attractions with images, ratings, and pricing
- **Smart Budget Management**: Add items to cart and calculate total trip costs
- **Smart Travel Guide**: Get personalized travel recommendations and planning assistance
- **Advanced Search & Filters**: Filter by category, price range, ratings, and location
- **Favorites & Save**: Save favorite places and itineraries for future trips
- **Interactive Maps**: Google Maps integration for location display and navigation

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend**: Firebase Firestore + Local JSON
- **AI Integration**: Google Gemini API
- **Maps**: Google Maps Flutter Plugin
- **Authentication**: Firebase Auth

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

### 🔑 API Configuration

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
│   ├── models/          # Data models
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Local & remote data sources
├── domain/              # Business logic
│   ├── entities/        # Domain entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
├── presentation/        # UI layer
│   ├── screens/         # App screens
│   ├── widgets/         # Reusable widgets
│   ├── providers/       # Riverpod providers
│   └── theme/           # App theme & styling
└── main.dart           # App entry point
```

## 🎯 Development Phases

### Phase 1: Project Setup ✅ COMPLETED
- [x] Create Flutter project structure
- [x] Set up dependencies and configuration
- [x] Create data models with JSON serialization
- [x] Set up Riverpod state management
- [x] Configure routing and app theme

### Phase 2: UI Implementation
- [ ] Create reusable widgets and components
- [ ] Build listing screens (hotels, restaurants, attractions)
- [ ] Implement search and filter functionality
- [ ] Create detail screens for each item type

### Phase 3: Core Features
- [ ] Cart and budget management system
- [ ] Favorites functionality
- [ ] User preferences and settings

### Phase 4: API Integration
- [ ] Google Gemini API for AI itineraries
- [ ] Google Maps integration
- [ ] Firebase Firestore setup

### Phase 5: Polish & Deploy
- [ ] Testing and optimization
- [ ] App store preparation
- [ ] Release builds

## 💻 Development Commands

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

## 📱 Development Tips

- Use sample JSON data for initial development
- Test frequently with hot reload
- Follow Riverpod best practices for state management
- Implement proper error handling
- Keep UI components reusable and consistent

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