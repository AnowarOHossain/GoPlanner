# Google Maps Setup Instructions

## Overview
This document provides step-by-step instructions to enable Google Maps functionality in the GoPlanner Flutter app.

## Prerequisites
- Google Cloud Console account
- Android Studio/VS Code with Flutter setup
- Flutter project with Maps screen implementation

## Step 1: Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Directions API
   - Geolocation API

4. Go to "Credentials" and create an API key
5. Restrict the API key to your app's package name

## Step 2: Android Configuration

### Add API Key to AndroidManifest.xml
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application>
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_API_KEY_HERE"/>
</application>
```

### Update build.gradle
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## Step 3: iOS Configuration

### Add API Key to AppDelegate.swift
```swift
// ios/Runner/AppDelegate.swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Update Info.plist
```xml
<!-- ios/Runner/Info.plist -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show your position on the map.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to show your position on the map.</string>
```

## Step 4: Update pubspec.yaml

Dependencies are already added:
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  location: ^5.0.3
```

## Step 5: Update Constants File

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String googleMapsApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
  // ... other constants
}
```

## Step 6: Test the Implementation

1. Run `flutter pub get`
2. Connect your device/emulator
3. Run `flutter run`
4. Navigate to Maps & Navigation page
5. Grant location permissions when prompted
6. Verify map loads and location features work

## Security Best Practices

1. **Restrict API Key**: Always restrict your API key to specific apps/domains
2. **Environment Variables**: Use environment variables for API keys in production
3. **Obfuscation**: Consider obfuscating API keys in release builds
4. **Monitoring**: Monitor API usage in Google Cloud Console

## Troubleshooting

### Common Issues:

1. **Map not loading**:
   - Check API key configuration
   - Verify APIs are enabled in Google Cloud Console
   - Check network connectivity

2. **Location not working**:
   - Verify location permissions in app settings
   - Check location services are enabled on device
   - Test on physical device (location may not work on emulator)

3. **Build errors**:
   - Run `flutter clean` and `flutter pub get`
   - Check minSdkVersion is 21 or higher for Android
   - Verify iOS deployment target is 9.0 or higher

### Debug Commands:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check location permissions
adb shell dumpsys location

# View app logs
flutter logs
```

## Current Features Ready for Google Maps

✅ Location services integration
✅ Permission handling
✅ Places listing with coordinates
✅ Navigation interface
✅ Filter and search functionality
✅ Distance calculation
✅ Interactive map placeholder

## Next Steps After API Configuration

1. Replace map placeholder with GoogleMap widget
2. Add real-time location tracking
3. Implement turn-by-turn navigation
4. Add places search functionality
5. Enable route planning with multiple waypoints

## Support

For additional help:
- [Google Maps Flutter Documentation](https://pub.dev/packages/google_maps_flutter)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Flutter Location Package](https://pub.dev/packages/location)