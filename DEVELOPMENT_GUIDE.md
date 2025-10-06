# GoPlanner Development Guide

## 🚀 Development Phases

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

## 🛠️ Setup Instructions

### Installation
```bash
# Navigate to project directory
cd C:\Users\Anowar\Desktop\GoPlanner

# Install dependencies
flutter pub get

# Generate code files
dart run build_runner build

# Run the app
flutter run
```

### API Configuration
Update `lib/core/constants/app_constants.dart` with your API keys:
```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';
```

### Firebase Setup
1. Create Firebase project at https://console.firebase.google.com
2. Add Android/iOS apps to your project
3. Download and place configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

## � Development Commands

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Build release
flutter build apk --release
```

## 📱 Development Tips

- Use sample JSON data for initial development
- Test frequently with hot reload
- Follow Riverpod best practices for state management
- Implement proper error handling
- Keep UI components reusable and consistent

## 📂 Project Structure

```
lib/
├── core/                 # App constants, services, utilities
├── data/                 # Models, repositories, data sources
├── presentation/         # UI screens, widgets, providers
└── main.dart            # App entry point
```

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Google Gemini API](https://ai.google.dev/docs)

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