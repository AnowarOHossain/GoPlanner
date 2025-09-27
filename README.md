# GoPlanner - AI-Powered Travel Planning App

A comprehensive Flutter mobile application for travel planning with AI-powered itinerary generation, budget management, and location services.

## Features

- **Browse & Discover**: Hotels, restaurants, and attractions with images, ratings, and pricing
- **Smart Budget Management**: Add items to cart and calculate total trip costs
- **AI-Powered Planning**: Generate personalized day-by-day itineraries using Google Gemini API
- **Advanced Search & Filters**: Filter by category, price range, ratings, and location
- **Favorites & Save**: Save favorite places and itineraries for future trips
- **Interactive Maps**: Google Maps integration for location display and navigation

## Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend**: Firebase Firestore + Local JSON
- **AI Integration**: Google Gemini API
- **Maps**: Google Maps Flutter Plugin
- **Authentication**: Firebase Auth

## Getting Started

### Prerequisites

- Flutter SDK (3.16.0 or later)
- Dart SDK (3.2.0 or later)
- Android Studio / VS Code
- Firebase account
- Google Cloud Console account (for Maps & Gemini API)

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/goplanner.git
cd goplanner
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase (see setup guide below)
4. Add API keys for Google Maps and Gemini API
5. Run the app
```bash
flutter run
```

## Project Structure

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

## Development Guide

This project follows Clean Architecture principles with proper separation of concerns. See the detailed development guides in the `/docs` folder for step-by-step implementation instructions.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.