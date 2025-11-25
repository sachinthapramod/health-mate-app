# HealthMate – Personal Health Tracker App

A fully functional Flutter **mobile app** (Android & iOS) for tracking daily health metrics including steps walked, calories burned, and water intake.

> **Note:** This is a mobile-only app (Android/iOS). Web support is not included.

## Features

- ✅ Add daily health entries (steps, calories, water intake)
- ✅ View list of previous records
- ✅ Search/filter by date
- ✅ Update existing records
- ✅ Delete records (swipe to delete)
- ✅ Dashboard screen showing today's summary
- ✅ Dark mode support
- ✅ Material 3 design

## Architecture

The app follows clean architecture principles with:
- **Data Layer**: Models, Database (sqflite), Repositories
- **Presentation Layer**: Screens, Widgets, Providers (Riverpod)
- **Core Layer**: Theme, Utils, Shared Widgets

## Tech Stack

- **Flutter**: 3.24+
- **State Management**: Riverpod 2.5.1+
- **Database**: sqflite
- **UI**: Material 3

## Getting Started

### Prerequisites

- Flutter SDK (3.24 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- **Android SDK** (for Android builds)
- **Xcode** (for iOS builds, macOS only)

> **Mobile Platforms Only:** This app is configured for Android and iOS. Web, Windows, Linux, and macOS desktop support are not included.

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd health-mate-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

**Quick Commands:**
- `flutter run` - Run on connected device/emulator
- `flutter devices` - List available devices
- `flutter build apk` - Build Android APK
- See [docs/RUN_COMMANDS.md](docs/RUN_COMMANDS.md) for all commands

### Running in Android Studio

**Quick Start:**
1. Open Android Studio
2. **File** → **Open** → Select the project folder
3. Wait for indexing to complete
4. Click the **green Run button** (▶) or press **Shift + F10**
5. Select an emulator or connected device

**Detailed Instructions:** See [docs/ANDROID_STUDIO_SETUP.md](docs/ANDROID_STUDIO_SETUP.md) for complete setup guide.

**Prerequisites:**
- Android Studio with Flutter & Dart plugins installed
- Flutter SDK configured
- Android emulator or physical device connected

### Building APK

To build an APK for Android:

```bash
flutter build apk
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

For a split APK (smaller file size):
```bash
flutter build apk --split-per-abi
```

### Building for iOS

```bash
flutter build ios
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/database_test.dart
flutter test test/repository_test.dart
flutter test test/add_record_form_test.dart
```

## Project Structure

```
lib/
├── features/
│   └── health_records/
│       ├── data/
│       │   ├── models/
│       │   ├── db/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/
├── core/
│   ├── theme/
│   ├── utils/
│   └── widgets/
└── main.dart
```

## Database Schema

The app uses SQLite with the following schema:

| Field    | Type    | Constraints           |
|----------|---------|----------------------|
| id       | INTEGER | PRIMARY KEY AUTOINCREMENT |
| date     | TEXT    | NOT NULL             |
| steps    | INTEGER | NOT NULL             |
| calories | INTEGER | NOT NULL             |
| water    | INTEGER | NOT NULL             |

## Documentation

See the `/docs` folder for:
- **TECHNICAL_REPORT.md**: Complete technical documentation
- **ARCHITECTURE.md**: Architecture diagrams (Mermaid)
- **WIREFRAMES.md**: UI wireframes and mockups

## Dependencies

- `flutter_riverpod`: State management
- `sqflite`: Local database
- `path_provider`: File system paths
- `intl`: Date formatting
- `fl_chart`: Charts (for future features)

## License

This project is part of an assignment project.

## Author

Sithangas Assignment Project
