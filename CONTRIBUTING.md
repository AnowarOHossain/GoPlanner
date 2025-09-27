# Contributing to GoPlanner

Welcome to GoPlanner! We're excited to have you contribute to this AI-powered travel planning application. This guide will help you get started with contributing to the project.

## 🎯 Project Overview

GoPlanner is a Flutter mobile application that helps users plan their trips with AI assistance. The app features:
- Browse hotels, restaurants, and attractions
- AI-powered itinerary generation using Google Gemini API
- Budget management and cart functionality
- Google Maps integration for location services
- Firebase backend for data storage

## 👥 Team Members

- **Anowar O Hossain** (@AnowarOHossain) - Project Lead & Frontend Development
- **Kazi Shah Hamza** (@KaziShahHamza) - Firebase Integration & AI API Implementation

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:
- Flutter SDK 3.16.0 or later
- Dart SDK 3.2.0 or later
- Android Studio or VS Code with Flutter extensions
- Git for version control
- A GitHub account

### Setup Development Environment

1. **Clone the repository:**
```bash
git clone https://github.com/AnowarOHossain/GoPlanner.git
cd GoPlanner
```

2. **Install dependencies:**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

3. **Verify setup:**
```bash
flutter doctor
flutter analyze
```

4. **Run the project:**
```bash
flutter run
```

## 📋 Current Task Assignment

### 🔥 Firebase Integration (Assigned to: Kazi Shah Hamza)
**Priority: High**

#### Tasks:
- [ ] Set up Firebase project and configuration
- [ ] Implement Firestore database structure
- [ ] Create Firebase Authentication setup
- [ ] Implement data services for CRUD operations
- [ ] Set up offline data synchronization

#### Files to work on:
- `lib/core/services/firebase_service.dart` (create)
- `lib/data/repositories/firebase_repository.dart` (create)
- `android/app/google-services.json` (configure)
- `ios/Runner/GoogleService-Info.plist` (configure)

### 🤖 Google Gemini API Integration (Assigned to: Kazi Shah Hamza)
**Priority: High**

#### Tasks:
- [ ] Configure Gemini API credentials
- [ ] Test and enhance existing Gemini service
- [ ] Implement error handling and retry logic
- [ ] Add prompt optimization for better responses
- [ ] Create itinerary validation and parsing

#### Files to work on:
- `lib/core/services/gemini_api_service.dart` (enhance existing)
- `lib/presentation/providers/itinerary_provider.dart` (create)
- API key configuration in constants

## 🏗 Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── constants/        # App constants, API keys
│   ├── services/         # API services, Firebase
│   └── utils/           # Helper functions
├── data/                # Data layer
│   ├── models/          # Data models
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Local & remote data sources
├── presentation/        # UI layer
│   ├── screens/         # App screens
│   ├── widgets/         # Reusable widgets
│   └── providers/       # Riverpod providers
└── main.dart           # App entry point
```

## 🔄 Development Workflow

### 1. Branch Strategy

We use **feature branches** for development:

```bash
# Create a new branch for your feature
git checkout -b feature/firebase-setup
git checkout -b feature/gemini-enhancement

# Examples:
git checkout -b firebase/firestore-integration
git checkout -b api/gemini-optimization
```

### 2. Commit Convention

Use conventional commits for clear history:

```bash
# Format: type(scope): description
git commit -m "feat(firebase): add Firestore database configuration"
git commit -m "fix(gemini): improve error handling for API failures"
git commit -m "docs(setup): update Firebase configuration guide"
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### 3. Pull Request Process

1. **Create feature branch:**
```bash
git checkout -b feature/your-feature-name
```

2. **Make your changes and commit:**
```bash
git add .
git commit -m "feat(scope): your descriptive message"
```

3. **Push to GitHub:**
```bash
git push origin feature/your-feature-name
```

4. **Create Pull Request:**
- Go to GitHub repository
- Click "New Pull Request"
- Select your branch
- Add detailed description
- Request review from team members

5. **Code Review:**
- Address feedback from reviewers
- Make necessary changes
- Push updates to the same branch

6. **Merge:**
- Once approved, merge to main branch
- Delete feature branch after merge

## 📋 Task Guidelines

### For Firebase Integration

#### 1. Project Setup
```bash
# Create Firebase project at https://console.firebase.google.com/
# Project name: GoPlanner
# Enable required services:
# - Firestore Database
# - Authentication
# - Cloud Storage (optional)
```

#### 2. Configuration Files
- Download `google-services.json` for Android
- Download `GoogleService-Info.plist` for iOS
- Place in respective directories
- Update `pubspec.yaml` with Firebase dependencies

#### 3. Database Structure
```
Collections:
├── users/
├── hotels/
├── restaurants/
├── attractions/
├── itineraries/
└── favorites/
```

#### 4. Implementation Priority
1. Basic Firebase setup and connection
2. Firestore database structure
3. CRUD operations for each collection
4. Authentication setup
5. Offline synchronization

### For Gemini API Enhancement

#### 1. API Configuration
- Secure API key management
- Environment-based configuration
- Rate limiting implementation

#### 2. Service Enhancement
- Improve existing `gemini_api_service.dart`
- Add response validation
- Implement retry logic for failed requests
- Add request/response logging

#### 3. Prompt Engineering
- Optimize prompts for better itinerary generation
- Add context awareness
- Implement prompt templates
- Add multilingual support

#### 4. Error Handling
- Network connectivity checks
- API quota management
- Graceful degradation

## 🧪 Testing Guidelines

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/services/firebase_service_test.dart

# Run with coverage
flutter test --coverage
```

### Test Requirements
- Write unit tests for services
- Test error scenarios
- Mock external dependencies
- Maintain test coverage above 80%

## 📝 Code Standards

### Flutter/Dart Guidelines
- Follow official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing
- Run `flutter analyze` to check for issues
- Use meaningful variable and function names

### File Naming Convention
- Use snake_case for file names
- Use descriptive names: `firebase_service.dart`, `gemini_api_service.dart`
- Group related files in appropriate folders

### Documentation
- Add documentation comments for public APIs
- Include examples in complex functions
- Update README.md when adding new features
- Document any setup requirements

## 🔧 Environment Setup

### API Keys Configuration

Create a `.env` file (not committed to repo):
```env
GEMINI_API_KEY=your_gemini_api_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key_here
```

Update `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  // Load from environment or use defaults
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
  );
}
```

### Firebase Configuration
1. Create Firebase project
2. Enable required services
3. Download configuration files
4. Update dependencies in `pubspec.yaml`
5. Initialize Firebase in `main.dart`

## 🐛 Issue Reporting

When reporting bugs:
1. Use the bug report template
2. Include steps to reproduce
3. Add screenshots if applicable
4. Specify device/platform information
5. Include error logs

## 💬 Communication

### Channels
- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Pull Request Reviews**: For code-related discussions

### Response Time
- Code reviews: Within 24 hours
- Issue responses: Within 48 hours
- Pull request merges: Within 2-3 days

## 🎯 Milestones

### Phase 1: Backend Integration (Current)
- [ ] Firebase setup and configuration
- [ ] Gemini API optimization
- [ ] Data services implementation

### Phase 2: UI Implementation
- [ ] Listings screens
- [ ] Cart functionality
- [ ] Maps integration

### Phase 3: Polish & Deploy
- [ ] Testing and optimization
- [ ] Store preparation
- [ ] Release

## 📚 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Google Gemini API](https://ai.google.dev/docs)

### Helpful Tools
- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)

## 🏆 Recognition

Contributors will be:
- Listed in the README.md
- Mentioned in release notes
- Given appropriate credit in app about section

## ❓ Getting Help

If you need help:
1. Check existing documentation
2. Search GitHub issues
3. Create a new issue with detailed description
4. Tag relevant team members for assistance

## 📄 License

By contributing to GoPlanner, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to GoPlanner! Together, we're building an amazing AI-powered travel planning experience. 🚀✈️