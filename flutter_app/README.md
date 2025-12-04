# EMM MoneyBox Flutter App

Personal finance management app built with Flutter for cross-platform support (Web, Android, iOS).

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── api/                # API client and endpoints
│   ├── models/             # Data models (freezed)
│   ├── routing/            # App routing (go_router)
│   ├── theme/              # App theming
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── dashboard/          # Home dashboard
│   ├── transactions/       # Transaction management
│   ├── categories/         # Category management
│   ├── statistics/         # Statistics and reports
│   ├── settings/           # App settings
│   └── data_management/    # Import/Export
└── shared/                 # Shared components
    ├── constants/          # App constants
    └── widgets/            # Reusable widgets
```

Each feature follows clean architecture:
- `presentation/` - UI components (screens, widgets)
- `domain/` - Business logic (use cases, entities)
- `data/` - Data layer (repositories, data sources)

## Tech Stack

- **State Management**: Riverpod 2.6
- **Routing**: go_router 14.6
- **HTTP Client**: Dio 5.7
- **Local Storage**: Hive 2.2, SharedPreferences 2.3
- **Code Generation**: freezed, json_serializable, riverpod_generator
- **Charts**: fl_chart 0.70
- **UI**: Material 3 with dark mode support

## Getting Started

### Prerequisites
- Flutter 3.38.3 or higher
- Dart 3.10.1 or higher

### Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

### Build

```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Configuration

Set the API base URL via environment variable:
```bash
flutter run --dart-define=API_BASE_URL=http://your-api-url:8080
```

Default: `http://localhost:8080`

## Development

### Code Generation

Run this after modifying models or providers:
```bash
flutter pub run build_runner watch
```

### Linting

```bash
flutter analyze
```

### Testing

```bash
flutter test
```

## Features (Planned)

See [TODO.md](../TODO.md) for the complete feature roadmap.

### Core Features
- Dashboard with financial overview
- Transaction management (income/expense)
- Category management
- Statistics and reports
- Data import/export
- Settings and preferences

### UI/UX
- Material 3 design
- Dark mode support
- Responsive layout
- Smooth animations
- Empty states
- Error handling

## API Integration

The app connects to the EMM-MoneyBox backend API. See [backend README](../backend/README.md) for API documentation.

## License

See [LICENSE](../LICENSE) file for details.
