# GoPlanner Development Guide

## 🚀 Step-by-Step Development Guide

### Phase 1: Project Setup ✅ COMPLETED
- [x] Create Flutter project structure
- [x] Set up dependencies in pubspec.yaml
- [x] Configure app constants and colors
- [x] Create data models with JSON serialization
- [x] Set up Riverpod state management
- [x] Configure routing with GoRouter
- [x] Design app theme and text styles

### Phase 2: Core UI Components (In Progress)
- [ ] Create reusable card widgets
- [ ] Build search and filter components
- [ ] Design listing item widgets
- [ ] Create navigation components
- [ ] Build rating and review widgets

### Phase 3: Listings Implementation
- [ ] Hotels browsing screen
- [ ] Restaurants browsing screen
- [ ] Attractions browsing screen
- [ ] Search and filter functionality
- [ ] Detail screens for each item type

### Phase 4: Cart & Budget System
- [ ] Cart functionality
- [ ] Budget calculation
- [ ] Cart summary screen
- [ ] Checkout process

### Phase 5: AI Integration
- [ ] Gemini API service setup
- [ ] Itinerary generation logic
- [ ] AI preferences configuration
- [ ] Generated itinerary display

### Phase 6: Maps Integration
- [ ] Google Maps setup
- [ ] Location display
- [ ] Navigation features
- [ ] Map markers and info windows

### Phase 7: Data Persistence
- [ ] Firebase Firestore configuration
- [ ] Local storage with Hive
- [ ] Favorites system
- [ ] Itinerary saving

### Phase 8: Deployment
- [ ] Android build configuration
- [ ] iOS build configuration
- [ ] Store deployment guides

## 🛠️ Getting Started

### Prerequisites
```bash
# Check Flutter installation
flutter doctor

# Ensure you have:
# - Flutter SDK 3.16.0+
# - Dart SDK 3.2.0+
# - Android Studio / VS Code
# - Git
```

### Initial Setup
```bash
# 1. Navigate to project directory
cd C:\Users\Anowar\Desktop\GoPlanner

# 2. Install dependencies
flutter pub get

# 3. Generate code files
dart run build_runner build

# 4. Run the app
flutter run
```

### API Keys Setup
Create a `.env` file in the root directory:
```env
GEMINI_API_KEY=your_gemini_api_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

Update `lib/core/constants/app_constants.dart` with your API keys.

### Firebase Setup
1. Create a Firebase project at https://console.firebase.google.com
2. Add Android/iOS apps to your Firebase project
3. Download configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

## 📱 Recommended Development Flow

### 1. Start with UI Components
Build reusable components first to ensure consistency across the app.

### 2. Implement Data Flow
Set up providers and services before building complex screens.

### 3. Test Frequently
Run the app regularly to catch issues early.

### 4. Use Mock Data
Start with local JSON data before implementing external APIs.

## 🎯 State Management Best Practices

### Riverpod Recommendations
- Use `@riverpod` code generation for type safety
- Keep providers focused on single responsibilities
- Implement proper error handling in all providers
- Use `AsyncValue` for async operations

### Example Provider Pattern:
```dart
@riverpod
class DataNotifier extends _$DataNotifier {
  @override
  AsyncValue<List<Model>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await service.fetchData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

## 🎨 UI/UX Guidelines

### Design Principles
- **Clean & Modern**: Use consistent spacing and colors
- **Responsive**: Ensure app works on different screen sizes
- **Accessible**: Include proper semantics and contrast
- **Intuitive**: Follow platform conventions

### Component Guidelines
- Use the predefined colors from `AppColors`
- Follow text styles from `AppTextStyles`
- Implement consistent padding (8, 16, 24px)
- Use elevation sparingly (cards, bottom sheets)

## 🔧 Development Commands

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 📂 Folder Structure Best Practices

```
lib/
├── core/                 # App-wide utilities
│   ├── constants/        # Colors, strings, configs
│   ├── utils/           # Helper functions
│   ├── services/        # API services
│   └── exceptions/      # Custom error classes
├── data/                # Data layer (models, repositories)
├── domain/              # Business logic layer
├── presentation/        # UI layer (screens, widgets, providers)
└── main.dart           # Entry point
```

## 🧪 Testing Strategy

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

## 📦 Deployment Checklist

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

## 🔍 Debugging Tips

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

## 📚 Next Steps

1. **Complete Phase 2**: Build the core UI components
2. **Implement Mock Data**: Create sample JSON files for testing
3. **Set up Firebase**: Configure Firestore and Authentication
4. **Integrate APIs**: Connect Gemini and Google Maps
5. **Test Thoroughly**: Implement comprehensive testing
6. **Optimize Performance**: Profile and optimize the app
7. **Prepare for Release**: Set up CI/CD and store listings

## 🤝 Contributing

When contributing to GoPlanner:
1. Follow the established folder structure
2. Use consistent naming conventions
3. Add proper documentation
4. Include tests for new features
5. Follow the code style guidelines

## 📞 Support

For questions or issues during development:
- Check the Flutter documentation: https://flutter.dev/docs
- Riverpod documentation: https://riverpod.dev
- Firebase documentation: https://firebase.google.com/docs