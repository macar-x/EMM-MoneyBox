# Flutter Testing Guide

Testing guide for Cashlens Flutter application.

## Prerequisites

- Flutter SDK 3.38.3+
- Dart 3.10.1+
- Backend API running (see [backend testing](../../backend/docs/TESTING.md))

## Quick Start

### 1. Install Dependencies

```bash
cd flutter
flutter pub get
```

### 2. Generate Code

```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes
flutter pub run build_runner watch
```

### 3. Run App

```bash
# Web (Chrome)
flutter run -d chrome

# With API URL
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080

# Android
flutter run -d android

# Windows
flutter run -d windows
```

## Unit Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/utils/date_util_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Writing Tests

```dart
// test/core/utils/currency_util_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cashlens/core/utils/currency_util.dart';

void main() {
  group('CurrencyUtil', () {
    test('formats USD correctly', () {
      expect(CurrencyUtil.format(1234.56, 'USD'), '\$1,234.56');
    });

    test('formats EUR correctly', () {
      expect(CurrencyUtil.format(1234.56, 'EUR'), '€1,234.56');
    });
  });
}
```

## Widget Testing

### Test Widgets

```bash
# Run widget tests
flutter test test/features/dashboard/presentation/

# Run specific widget test
flutter test test/features/dashboard/presentation/dashboard_screen_test.dart
```

### Example Widget Test

```dart
// test/features/dashboard/presentation/dashboard_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashlens/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard shows balance', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('Balance'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
  });
}
```

## Integration Testing

### Setup Integration Tests

```bash
# Create integration test directory
mkdir -p integration_test

# Create test file
touch integration_test/app_test.dart
```

### Run Integration Tests

```bash
# Run on Chrome
flutter test integration_test/app_test.dart -d chrome

# Run on Android
flutter test integration_test/app_test.dart -d android

# Run on Windows
flutter test integration_test/app_test.dart -d windows
```

### Example Integration Test

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cashlens/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete transaction flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to add transaction
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill form
      await tester.enterText(find.byKey(Key('amount_field')), '45.50');
      await tester.tap(find.text('Food & Dining'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify transaction appears
      expect(find.text('45.50'), findsOneWidget);
    });
  });
}
```

## Testing with Backend API

### 1. Start Backend

```bash
# In backend directory
cd backend
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
go run main.go server start -p 8080
```

### 2. Run Flutter with API

```bash
# In flutter directory
cd flutter
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

### 3. Test API Integration

Manual testing checklist:
- [ ] Dashboard loads data from API
- [ ] Add transaction creates record in backend
- [ ] Edit transaction updates backend
- [ ] Delete transaction removes from backend
- [ ] Categories load from API
- [ ] Statistics calculate correctly
- [ ] Error handling works (network errors, validation)

## Golden Tests (Visual Regression)

### Generate Golden Files

```bash
# Generate golden files
flutter test --update-goldens

# Run golden tests
flutter test test/golden/
```

### Example Golden Test

```dart
// test/golden/dashboard_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cashlens/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard golden test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardScreen()),
    );

    await expectLater(
      find.byType(DashboardScreen),
      matchesGoldenFile('golden/dashboard.png'),
    );
  });
}
```

## Performance Testing

### Measure Performance

```bash
# Run with performance overlay
flutter run --profile -d chrome

# Measure build time
flutter run --trace-startup --profile
```

### Profile App

```dart
// Use DevTools for profiling
// 1. Run app in profile mode
// 2. Open DevTools: flutter pub global run devtools
// 3. Connect to running app
// 4. Use Performance tab to analyze
```

## Linting and Analysis

### Run Analyzer

```bash
# Analyze code
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Format code
dart format lib/ test/
```

### Custom Lint Rules

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_single_quotes
```

## Testing Best Practices

### 1. Test Structure

```
test/
├── core/
│   ├── api/
│   ├── models/
│   └── utils/
├── features/
│   ├── dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── transactions/
├── golden/
└── helpers/
    └── test_helpers.dart
```

### 2. Mock Data

```dart
// test/helpers/test_helpers.dart
import 'package:cashlens/core/models/transaction.dart';

class TestData {
  static Transaction mockTransaction() {
    return Transaction(
      id: '1',
      amount: 45.50,
      date: DateTime.now(),
      category: 'Food & Dining',
      description: 'Lunch',
      type: TransactionType.expense,
    );
  }

  static List<Transaction> mockTransactions() {
    return [
      mockTransaction(),
      // ... more mock data
    ];
  }
}
```

### 3. Test Coverage Goals

- **Unit tests**: 80%+ coverage
- **Widget tests**: All screens and major widgets
- **Integration tests**: Critical user flows
- **Golden tests**: Key UI components

## Continuous Integration

### GitHub Actions Example

```yaml
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.3'
      
      - name: Install dependencies
        run: |
          cd flutter
          flutter pub get
      
      - name: Generate code
        run: |
          cd flutter
          flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Run tests
        run: |
          cd flutter
          flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: flutter/coverage/lcov.info
```

## Troubleshooting

### Common Issues

**Build runner fails:**
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Tests fail with provider errors:**
```dart
// Wrap widget with ProviderScope
await tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(home: YourWidget()),
  ),
);
```

**Golden tests fail on CI:**
```bash
# Update goldens in CI
flutter test --update-goldens --tags=golden
```

## Next Steps

1. Add unit tests for all services
2. Add widget tests for all screens
3. Create integration tests for user flows
4. Set up golden tests for UI components
5. Configure CI/CD pipeline
6. Achieve 80%+ test coverage

## See Also

- [Setup Guide](SETUP.md) - Platform-specific setup
- [Backend Testing](../../backend/docs/TESTING.md) - Backend testing guide
- [Flutter README](../README.md) - Flutter app documentation
