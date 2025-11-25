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

## Database Schema

### Table: health_records

| Field    | Type    | Constraints           |
|----------|---------|----------------------|
| id       | INTEGER | PRIMARY KEY AUTOINCREMENT |
| date     | TEXT    | NOT NULL             |
| steps    | INTEGER | NOT NULL             |
| calories | INTEGER | NOT NULL             |
| water    | INTEGER | NOT NULL             |

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

## References

Flutter Team. (2024). *Flutter Documentation*. https://docs.flutter.dev/

Riverpod Contributors. (2024). *Riverpod Documentation*. https://riverpod.dev/

SQLite Team. (2024). *SQLite Documentation*. https://www.sqlite.org/docs.html

Material Design Team. (2024). *Material Design 3*. https://m3.material.io/

Google. (2024). *sqflite Package*. https://pub.dev/packages/sqflite

