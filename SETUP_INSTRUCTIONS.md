# GoPlanner Setup Instructions

## 🚀 Quick Start Guide

### 1. Prerequisites
Before starting, ensure you have:
- Flutter SDK 3.16.0 or later
- Dart SDK 3.2.0 or later
- Android Studio or VS Code with Flutter extension
- Git for version control

### 2. Project Setup
```bash
# Navigate to the project directory
cd C:\Users\Anowar\Desktop\GoPlanner

# Install dependencies
flutter pub get

# Generate required code files
dart run build_runner build --delete-conflicting-outputs

# Check if everything is set up correctly
flutter doctor
```

### 3. API Keys Configuration

#### 3.1 Google Gemini API Key
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key for Gemini
3. Update `lib/core/constants/app_constants.dart`:
```dart
static const String geminiApiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
```

#### 3.2 Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android and iOS
3. Create API key with appropriate restrictions
4. Update `lib/core/constants/app_constants.dart`:
```dart
static const String googleMapsApiKey = 'YOUR_ACTUAL_GOOGLE_MAPS_KEY';
```

### 4. Firebase Setup

#### 4.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "GoPlanner"
3. Enable Firestore Database
4. Enable Authentication (optional for now)

#### 4.2 Android Configuration
1. Add Android app to Firebase project
2. Package name: `com.example.goplanner` (or your chosen package)
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### 4.3 iOS Configuration
1. Add iOS app to Firebase project
2. Bundle ID: `com.example.goplanner` (or your chosen bundle ID)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### 5. Development Environment Setup

#### 5.1 VS Code Extensions
Install these recommended extensions:
- Flutter
- Dart
- Flutter Widget Snippets
- Riverpod Snippets

#### 5.2 Android Studio Plugins
Install these plugins:
- Flutter
- Dart
- Riverpod Snippets

### 6. Running the App

#### 6.1 Debug Mode
```bash
# Run on connected device/emulator
flutter run

# Run with hot reload enabled
flutter run --hot
```

#### 6.2 Release Mode
```bash
# Build APK for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

### 7. Testing the Setup

#### 7.1 Verify Installation
```bash
# Check for any issues
flutter doctor -v

# Analyze code
flutter analyze

# Run tests
flutter test
```

#### 7.2 Test Features
1. Launch the app
2. Navigate through different screens
3. Test search functionality (will show placeholder data)
4. Test cart functionality
5. Verify no runtime errors

### 8. Development Tips

#### 8.1 Code Generation
When you modify models or providers, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 8.2 Debugging
- Use Flutter Inspector for widget debugging
- Use Riverpod Inspector for state debugging
- Check debug console for API errors

#### 8.3 Hot Reload
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

### 9. Common Issues & Solutions

#### 9.1 Build Runner Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### 9.2 Firebase Connection Issues
- Verify configuration files are in correct locations
- Check package names match Firebase configuration
- Ensure Firebase project has correct services enabled

#### 9.3 API Key Issues
- Double-check API keys are correctly set in constants
- Verify API keys have correct permissions/restrictions
- Check quotas and billing settings

### 10. Next Development Steps

#### Phase 1: Complete Current Setup ✅
- [x] Project structure
- [x] Data models
- [x] State management
- [x] Basic UI components
- [x] Sample data

#### Phase 2: Implement Core Features
- [ ] Complete UI screens
- [ ] API integrations
- [ ] Maps functionality
- [ ] Cart system
- [ ] AI itinerary generation

#### Phase 3: Polish & Deploy
- [ ] Testing
- [ ] Performance optimization
- [ ] Store preparation
- [ ] Release

### 11. Resources

#### Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)

#### Sample Code
- Check `assets/data/` for sample JSON files
- Review `lib/presentation/widgets/common_widgets.dart` for UI examples
- See `lib/core/services/gemini_api_service.dart` for AI integration

### 12. Support

If you encounter issues:
1. Check the error message carefully
2. Search Flutter/Riverpod documentation
3. Check GitHub issues for similar problems
4. Verify all setup steps were followed correctly

### 13. Project Structure Overview

```
GoPlanner/
├── lib/
│   ├── core/                 # Core functionality
│   │   ├── constants/        # App constants
│   │   └── services/         # API services
│   ├── data/
│   │   └── models/           # Data models
│   ├── presentation/
│   │   ├── providers/        # Riverpod providers
│   │   ├── routes/           # Navigation
│   │   ├── theme/            # App theme
│   │   └── widgets/          # Reusable widgets
│   └── main.dart             # Entry point
├── assets/
│   └── data/                 # Sample JSON data
├── android/                  # Android configuration
├── ios/                      # iOS configuration
└── pubspec.yaml              # Dependencies
```

Ready to start building GoPlanner! 🚀