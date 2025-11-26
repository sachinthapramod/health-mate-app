# HealthMate - Technical Report

## Overview

HealthMate is a cross-platform mobile application built with Flutter that enables users to track their daily health metrics including steps walked, calories burned, and water intake. The application follows clean architecture principles with clear separation of concerns, making it maintainable and scalable.

## Features

### Core Features

1. **Add Daily Health Entries**
   - Steps walked
   - Calories burned
   - Water intake (ml)
   - Date picker for selecting entry date

2. **View Records**
   - List of all previous records
   - Sorted by latest first
   - Detailed view with all metrics

3. **Search & Filter**
   - Filter records by date
   - Clear filter functionality

4. **Update Records**
   - Edit existing health records
   - Pre-filled form with current values
   - Same validation rules as add screen

5. **Delete Records**
   - Swipe to delete functionality
   - Confirmation dialog before deletion

6. **Dashboard**
   - Today's summary display
   - Visual cards with icons and color coding
   - Real-time data updates

### Extra Features

7. **Weekly Summary Graphs**
   - Interactive charts using fl_chart
   - Bar charts for Steps and Calories
   - Line chart for Water Intake
   - Last 7 days data visualization
   - Smooth animations and tooltips
   - Auto-aggregation by day

8. **Daily Notifications**
   - Daily reminder at 9:00 AM
   - Water reminder every 3 hours
   - User-configurable from Settings
   - Permission handling
   - Persistent preferences using SharedPreferences

9. **BMI Calculator**
   - Calculate BMI from height and weight
   - Visual BMI indicator with color coding
   - Category classification (Underweight, Normal, Overweight, Obese)
   - Save BMI history to database
   - View and delete BMI records

## Architecture

### Clean Architecture Layers

The application follows a clean architecture pattern with three main layers:

1. **Data Layer** (`lib/features/health_records/data/`)
   - Models: Data transfer objects
   - Database: SQLite database helper
   - Repositories: Data access abstraction

2. **Presentation Layer** (`lib/features/health_records/presentation/`)
   - Screens: UI screens
   - Widgets: Reusable UI components
   - Providers: State management with Riverpod

3. **Core Layer** (`lib/core/`)
   - Theme: App-wide theming
   - Utils: Utility functions
   - Widgets: Shared UI components

### State Management

The application uses **Riverpod** (version 2.5.1) for state management:

- **Providers**: Define data sources and business logic
- **StateNotifier**: Manages complex state with async operations
- **FutureProvider**: Handles async data loading
- **ConsumerWidget**: Connects UI to state

### Dependency Injection

Riverpod providers are used for dependency injection:
- Repository provider
- Database helper (singleton)
- State notifiers

## Folder Structure

```
lib/
├── features/
│   └── health_records/
│       ├── data/
│       │   ├── models/
│       │   │   └── health_record.dart
│       │   ├── db/
│       │   │   └── database_helper.dart
│       │   └── repositories/
│       │       └── health_record_repository.dart
│       ├── presentation/
│       │   ├── screens/
│       │   │   ├── dashboard_screen.dart
│       │   │   ├── add_record_screen.dart
│       │   │   ├── records_list_screen.dart
│       │   │   └── update_record_screen.dart
│       │   ├── widgets/
│       │   └── providers/
│       │       └── health_record_provider.dart
│       └── health_records.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── date_formatter.dart
│   └── widgets/
│       └── health_metric_card.dart
└── main.dart
```

## Extra Features Details

### Weekly Summary Graphs

The Weekly Summary feature provides visual insights into health trends over the past 7 days:

**Implementation:**
- Repository: `WeeklySummaryRepository` queries records for the last 7 days
- Provider: `weeklySummaryProvider` manages state with Riverpod
- Screen: `WeeklySummaryScreen` displays 3 interactive charts

**Charts:**
1. **Steps Bar Chart**: Shows daily step count with green color coding
2. **Calories Bar Chart**: Displays daily calorie burn in red
3. **Water Intake Line Chart**: Visualizes water consumption trend in blue

**Features:**
- Auto-aggregates multiple records per day
- Fills missing days with zero values
- Smooth animations (500ms duration)
- Interactive tooltips on touch
- Responsive design with proper scaling

### Daily Notifications

**Architecture:**
- `NotificationService`: Handles local notifications using `flutter_local_notifications`
- `NotificationManager`: Manages notification preferences and scheduling
- Uses `timezone` package for accurate scheduling
- Preferences stored with `SharedPreferences`

**Notification Types:**
1. **Daily Reminder**: Scheduled for 9:00 AM daily
   - Message: "Don't forget to log your health today!"
   - Repeats every day at the same time

2. **Water Reminder**: Every 3 hours
   - Message: "Time to drink water! Stay hydrated 💧"
   - Configurable interval

**Permissions:**
- Android: `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`
- iOS: Alert, Badge, Sound permissions

### BMI Calculator

**Formula:**
```
BMI = weight (kg) / (height (m))²
BMI = weight / ((height/100)²)
```

**Categories:**
- Underweight: BMI < 18.5 (Blue)
- Normal: 18.5 ≤ BMI < 25 (Green)
- Overweight: 25 ≤ BMI < 30 (Orange)
- Obese: BMI ≥ 30 (Red)

**Database Schema:**
- Table: `bmi_history`
- Fields: id, date, weight, height, bmi
- Stores calculation history for tracking

**Features:**
- Real-time BMI calculation
- Visual indicator bar with color coding
- Save results to database
- View history with date and category badges
- Delete individual records

## Database Schema

### Table: health_records

| Field    | Type    | Constraints           |
|----------|---------|----------------------|
| id       | INTEGER | PRIMARY KEY AUTOINCREMENT |
| date     | TEXT    | NOT NULL             |
| steps    | INTEGER | NOT NULL             |
| calories | INTEGER | NOT NULL             |
| water    | INTEGER | NOT NULL             |

### Table: bmi_history

| Field    | Type    | Constraints           |
|----------|---------|----------------------|
| id       | INTEGER | PRIMARY KEY AUTOINCREMENT |
| date     | TEXT    | NOT NULL             |
| weight   | REAL    | NOT NULL             |
| height   | REAL    | NOT NULL             |
| bmi      | REAL    | NOT NULL             |

### Database Operations

The `DatabaseHelper` class provides the following operations:

- `insert(HealthRecord)`: Insert a new record
- `getAllRecords()`: Retrieve all records (sorted by date DESC)
- `getRecordById(int)`: Get a specific record by ID
- `getRecordsByDate(String)`: Filter records by date
- `getTodayRecord()`: Get today's record
- `update(HealthRecord)`: Update an existing record
- `delete(int)`: Delete a record by ID

### Pre-loaded Data

On first launch, the database automatically inserts three dummy records:
- 2 days ago: 8500 steps, 2200 calories, 2000ml water
- 1 day ago: 10200 steps, 2400 calories, 2500ml water
- Today: 7500 steps, 2000 calories, 1800ml water

## CRUD Sample Code

### Create Record

```dart
final record = HealthRecord(
  date: DateTime.now().toIso8601String(),
  steps: 10000,
  calories: 2500,
  water: 2000,
);

await repository.createRecord(record);
```

### Read Records

```dart
// Get all records
final records = await repository.getAllRecords();

// Get by ID
final record = await repository.getRecordById(1);

// Filter by date
final dateRecords = await repository.getRecordsByDate('2024-01-01');
```

### Update Record

```dart
final updatedRecord = existingRecord.copyWith(
  steps: 12000,
  calories: 2800,
);

await repository.updateRecord(updatedRecord);
```

### Delete Record

```dart
await repository.deleteRecord(recordId);
```

## UI Components

### Material 3 Components Used

- **NavigationBar**: Bottom navigation
- **FilledButton**: Primary actions
- **ElevatedButton**: Secondary actions
- **OutlinedButton**: Tertiary actions
- **OutlinedTextField**: Form inputs
- **DatePickerDialog**: Date selection
- **Card**: Content containers
- **ListTile**: List items

### Color Coding

- **Steps**: Green (Colors.green)
- **Calories**: Red (Colors.red)
- **Water**: Blue (Colors.blue)

## Testing

### Unit Tests

1. **Database Tests** (`test/database_test.dart`)
   - Insert operations
   - Retrieve operations
   - Update operations
   - Delete operations
   - Date filtering

2. **Repository Tests** (`test/repository_test.dart`)
   - CRUD operations
   - Error handling
   - Date filtering

### Widget Tests

1. **Add Record Form Test** (`test/add_record_form_test.dart`)
   - Form validation
   - Empty field validation
   - Numeric validation
   - Negative number validation

### Extra Features Test Cases

1. **BMI Calculation Tests**
   - Verify BMI formula correctness
   - Test category classification
   - Validate color coding
   - Test edge cases (zero, negative values)

2. **Notification Scheduling Tests**
   - Verify daily notification scheduling
   - Test water reminder intervals
   - Validate permission handling
   - Test enable/disable functionality

3. **Weekly Summary Tests**
   - Verify 7-day date range calculation
   - Test data aggregation by day
   - Validate missing day handling
   - Test chart data formatting

## Issues & Fixes

### Issue 1: Database Path on Windows
**Problem**: Initial database path configuration issues on Windows.

**Solution**: Used `sqflite`'s built-in `getDatabasesPath()` method which handles cross-platform paths correctly.

### Issue 2: Date Comparison for Today's Record
**Problem**: Exact date string matching failed due to time components.

**Solution**: Implemented LIKE query with date prefix matching for today's records.

### Issue 3: State Management Updates
**Problem**: UI not updating after CRUD operations.

**Solution**: Implemented proper state refresh using `loadRecords()` after each operation in the StateNotifier.

## Dependencies

### Core Dependencies
- `flutter_riverpod: ^2.5.1` - State management
- `sqflite: ^2.3.0` - Local database
- `path_provider: ^2.1.1` - File system paths
- `intl: ^0.19.0` - Date formatting

### Extra Features Dependencies
- `fl_chart: ^0.66.0` - Charts and graphs
- `flutter_local_notifications: ^17.0.0` - Local notifications
- `shared_preferences: ^2.2.2` - User preferences storage
- `timezone: ^0.9.4` - Timezone handling (transitive)

## References

Flutter Team. (2024). *Flutter Documentation*. https://docs.flutter.dev/

Riverpod Contributors. (2024). *Riverpod Documentation*. https://riverpod.dev/

SQLite Team. (2024). *SQLite Documentation*. https://www.sqlite.org/docs.html

Material Design Team. (2024). *Material Design 3*. https://m3.material.io/

Google. (2024). *sqflite Package*. https://pub.dev/packages/sqflite

Iman Khoshabi. (2024). *fl_chart Package*. https://pub.dev/packages/fl_chart

Maido Kaara. (2024). *flutter_local_notifications Package*. https://pub.dev/packages/flutter_local_notifications

Flutter Team. (2024). *shared_preferences Package*. https://pub.dev/packages/shared_preferences

