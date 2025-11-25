import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/features/health_records/presentation/screens/add_record_screen.dart';

void main() {
  group('AddRecordScreen Form Validation', () {
    testWidgets('should show validation errors for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddRecordScreen(),
          ),
        ),
      );

      // Find the save button
      final saveButton = find.text('Save Record');
      expect(saveButton, findsOneWidget);

      // Tap save button without filling fields
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter steps'), findsOneWidget);
    });

    testWidgets('should validate numeric input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddRecordScreen(),
          ),
        ),
      );

      // Enter non-numeric value in steps field
      final stepsField = find.widgetWithText(TextFormField, '');
      if (stepsField.evaluate().isNotEmpty) {
        await tester.enterText(stepsField.first, 'abc');
        await tester.pumpAndSettle();

        // Tap save button
        final saveButton = find.text('Save Record');
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Should show validation error
        expect(find.text('Please enter a valid number'), findsWidgets);
      }
    });

    testWidgets('should validate negative numbers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddRecordScreen(),
          ),
        ),
      );

      // Find text fields by their labels
      final stepsFinder = find.byType(TextFormField).first;
      
      await tester.enterText(stepsFinder, '-100');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.text('Save Record');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation error for negative value
      expect(find.text('Value cannot be negative'), findsWidgets);
    });

    testWidgets('should display date picker button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddRecordScreen(),
          ),
        ),
      );

      // Should find date picker button
      expect(find.textContaining('Date:'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should have all required input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddRecordScreen(),
          ),
        ),
      );

      // Should find all input fields
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('Water Intake (ml)'), findsOneWidget);
    });
  });
}

