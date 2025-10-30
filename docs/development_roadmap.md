# GoPlanner Development Roadmap

A focused guide to complete the essential features for GoPlanner travel planning application.

##  Current Project Status

###  Completed Features
- **Core App Structure**: Flutter app with Riverpod state management
- **UI Screens**: Home, Hotels, Restaurants, Attractions, Profile, Maps, Budget Analysis, Favorites
- **Data Management**: 60+ Bangladesh tourism items (20 hotels, 20 restaurants, 20 attractions)
- **Navigation**: GoRouter with custom back button handling
- **Search & Filters**: Advanced filtering by category, price, location, ratings
- **Budget System**: Complete cart functionality with expense breakdown
- **Favorites System**: Multi-tab organization for saved items
- **Profile Management**: Travel statistics and interactive quick actions

###  Current Development Phase
**Phase 5**: Local functionality complete, ready for essential API integrations

---

##  Essential Development Tasks (MUST-HAVE)

###  HIGH PRIORITY - Core Features

#### 1. Google Maps Integration
**Status**: Setup complete, needs API configuration
**Time Estimate**: 1-2 days

** Step-by-Step Tasks**:
- [ ] **Get Google Maps API Key**
  - Go to [Google Cloud Console](https://console.cloud.google.com/)
  - Create/select project and enable APIs: Maps SDK (Android/iOS), Places API, Directions API
  - Create API key and restrict to app package name

- [ ] **Android Configuration**
  - Add API key to `android/app/src/main/AndroidManifest.xml`:
    ```xml
    <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY_HERE"/>
    ```
  - Verify minSdkVersion 21+ in `android/app/build.gradle`

- [ ] **iOS Configuration**
  - Add API key to `ios/Runner/AppDelegate.swift`:
    ```swift
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    ```
  - Add location permissions to `ios/Runner/Info.plist`

- [ ] **Update Constants**
  - Configure API key in `lib/core/constants/app_constants.dart`
  - Replace placeholder map with GoogleMap widget in `lib/presentation/screens/maps_screen.dart`

- [ ] **Test Implementation**
  - Run `flutter pub get` and `flutter run`
  - Test location permissions and map loading
  - Verify on physical devices

**Files to modify**:
- `lib/core/constants/app_constants.dart`
- `lib/presentation/screens/maps_screen.dart`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

#### 2. AI-Powered Itinerary Generator (Gemini API)
**Status**: API service prepared, needs integration
**Time Estimate**: 3-4 days

** Step-by-Step Tasks**:
- [ ] **Get Google Gemini API Key**
  - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
  - Create API key for Gemini Pro model
  - Add to `lib/core/constants/app_constants.dart`

- [ ] **Complete Service Implementation**
  - Finish `lib/core/services/gemini_api_service.dart` implementation
  - Add error handling and rate limiting
  - Test API connectivity and responses

- [ ] **Build UI Screens**
  - Create `lib/presentation/screens/itinerary_generator_screen.dart`
  - Add form for travel preferences and dates
  - Create `lib/presentation/screens/itinerary_detail_screen.dart`
  - Add save/share functionality

- [ ] **Implement State Management**
  - Create `lib/data/providers/itinerary_provider.dart`
  - Add generated itinerary storage
  - Implement itinerary history

- [ ] **AI Prompt Engineering**
  - Optimize prompts for Bangladesh travel
  - Test with real Bangladesh tourism data
  - Add fallback responses for API failures

**Files to create/modify**:
- `lib/presentation/screens/itinerary_generator_screen.dart`
- `lib/presentation/screens/itinerary_detail_screen.dart`
- `lib/data/providers/itinerary_provider.dart`
- `lib/core/services/gemini_api_service.dart`

#### 3. Firebase Backend Integration
**Status**: Structure ready, needs implementation
**Time Estimate**: 4-5 days

** Step-by-Step Tasks**:
- [ ] **Firebase Project Setup**
  - Go to [Firebase Console](https://console.firebase.google.com/)
  - Create new project "GoPlanner"
  - Enable Firestore Database and Authentication

- [ ] **Configure Firebase for Platforms**
  - Add Android app with package name
  - Download `google-services.json` → `android/app/`
  - Add iOS app with bundle identifier  
  - Download `GoogleService-Info.plist` → `ios/Runner/`

- [ ] **Install Firebase Dependencies**
  - Add to pubspec.yaml: `firebase_core`, `cloud_firestore`, `firebase_auth`
  - Run `flutter pub get`
  - Initialize Firebase in `main.dart`

- [ ] **Create Firebase Service**
  - Build `lib/core/services/firebase_service.dart`
  - Implement CRUD operations for hotels, restaurants, attractions
  - Add real-time listeners

- [ ] **Data Migration**
  - Create `lib/data/repositories/firebase_repository.dart`
  - Migrate local JSON data to Firestore collections
  - Set up data structure and indexes

- [ ] **Update Providers**
  - Modify existing providers to use Firebase
  - Add real-time data synchronization

**Files to create/modify**:
- `lib/core/services/firebase_service.dart`
- `lib/data/repositories/firebase_repository.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

#### 4. Basic User Authentication
**Status**: Not started
**Time Estimate**: 2-3 days

** Step-by-Step Tasks**:
- [ ] **Firebase Auth Setup**
  - Enable Authentication in Firebase Console
  - Configure Email/Password sign-in method

- [ ] **Create Basic Auth Screens**
  - Build `lib/presentation/screens/auth/login_screen.dart`
  - Build `lib/presentation/screens/auth/signup_screen.dart`
  - Add simple form validation

- [ ] **Implement Auth Service**
  - Create `lib/core/services/auth_service.dart`
  - Add sign-up, sign-in, sign-out methods

- [ ] **State Management**
  - Create `lib/data/providers/auth_provider.dart`
  - Add authentication state management

- [ ] **Make Data User-Specific**
  - Make favorites user-specific
  - Make budget data user-specific

**Files to create**:
- `lib/presentation/screens/auth/login_screen.dart`
- `lib/presentation/screens/auth/signup_screen.dart`
- `lib/core/services/auth_service.dart`
- `lib/data/providers/auth_provider.dart`

---

##  Quick Development Commands

```bash
# Project setup
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Development
flutter run
flutter run --debug

# Testing
flutter test
flutter analyze

# Code formatting
dart format lib/

# Clean builds
flutter clean
flutter pub get

# Firebase setup
firebase login
flutterfire configure

# Build release
flutter build apk --release
```

---

##  Essential Milestone Goals

###  CURRENT FOCUS (This Week)
- [ ] Google Maps API integration
- [ ] Start Firebase setup

###  NEXT PHASE (Next Week)  
- [ ] Complete Firebase data migration
- [ ] Implement Gemini AI features

###  COMPLETION TARGET
- **Week 2**: Maps and Firebase working
- **Week 4**: AI features functional
- **Week 6**: Basic auth system complete
- **Week 8**: App ready for release

---

##  Essential Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Google Gemini API Documentation](https://developers.generativeai.google/)
- [Riverpod Documentation](https://riverpod.dev/)

---

*Last Updated: October 15, 2025*
*Essential Features Only - Focused Development Plan*