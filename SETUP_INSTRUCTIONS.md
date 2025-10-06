# GoPlanner Setup Instructions

## 🚀 Quick Start Guide

### Prerequisites
- Flutter SDK 3.16.0 or later
- Dart SDK 3.2.0 or later
- Android Studio or VS Code with Flutter extension

### Project Setup
```bash
# Navigate to the project directory
cd C:\Users\Anowar\Desktop\GoPlanner

# Install dependencies
flutter pub get

# Generate required code files
dart run build_runner build --delete-conflicting-outputs

# Check setup
flutter doctor
```

### API Keys Configuration

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

