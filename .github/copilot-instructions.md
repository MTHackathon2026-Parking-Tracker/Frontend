# Copilot Instructions - HackMT2026 Flutter Frontend

## Project Overview
This is a Flutter mobile application (HackMT2026 hackathon project). It follows Flutter's standard multi-platform architecture supporting iOS, Android, macOS, Linux, and Windows from a single Dart codebase.

**Current State**: Early-stage Flutter project with minimal custom code. Only `lib/main.dart` contains app logic (a basic counter demo app).

## Architecture & Key Structure

### Core Entry Point
- **[lib/main.dart](lib/main.dart)** - Application entry point
  - `main()` function initializes the app via `runApp()`
  - `MyApp` (StatelessWidget) defines theme and navigation routing
  - `MyHomePage` (StatefulWidget) and `_MyHomePageState` show Flutter state management pattern
  - Uses Material Design theme with `ColorScheme.fromSeed()`

### Flutter Platform Structure
- **android/** - Android native code and Gradle build configuration
- **ios/** - iOS native code and Xcode project  
- **web/** - Web platform files (HTML, manifest, icons)
- **windows/**, **linux/**, **macos/** - Desktop platform implementations
- **test/** - Unit and widget tests (currently has `widget_test.dart`)

### Configuration Files
- **pubspec.yaml** - Dart package manifest defining dependencies and Flutter configuration
- **analysis_options.yaml** - Dart linter rules (includes `package:flutter_lints/flutter.yaml`)
- **pubspec.lock** - Dependency lock file (auto-generated)

## Development Workflow & Commands

### Running the App
```bash
flutter run
```
- Launches app on connected device/emulator
- Supports hot reload (`r` key in CLI) for fast iteration without losing state
- Use hot restart (`R` key) to reset app state completely

### Code Analysis & Linting
```bash
flutter analyze
```
- Runs Dart analyzer using rules from `analysis_options.yaml`
- Fix lint issues with: `dart fix --apply` or IDE quick fixes

### Dependencies
```bash
flutter pub get          # Fetch dependencies
flutter pub upgrade      # Update to latest compatible versions
flutter pub upgrade --major-versions  # Allow major version bumps
```

### Testing
```bash
flutter test
```
- Runs unit tests and widget tests from `test/` directory
- [test/widget_test.dart](test/widget_test.dart) is the example test file

### Building for Release
```bash
flutter build <platform>  # Builds APK, IPA, web bundle, or desktop executable
```

## Key Patterns & Conventions

### Widget Structure (from main.dart example)
1. **StatelessWidget** for widgets that don't manage internal state
2. **StatefulWidget** paired with **State<T>** class for stateful UIs
3. Use `setState(() { })` to trigger rebuilds when state changes
4. Private State classes named with underscore: `_MyHomePageState`

### Material Design Theme
- Uses `ColorScheme.fromSeed()` with seed color for automatic material theme generation
- Current theme seed: `Colors.deepPurple`
- Theme configured in `MyApp.build()` method under `MaterialApp.theme`

### Naming Conventions (Dart Standard)
- Classes: PascalCase (e.g., `MyApp`, `MyHomePage`)
- Files: snake_case (e.g., `main.dart`)
- Functions/variables: camelCase (e.g., `_incrementCounter()`, `_counter`)
- Private members: prefix with underscore (e.g., `_counter`, `_MyHomePageState`)

### Lint Rules Enforced
- Based on `package:flutter_lints` (recommended Flutter lint set)
- Currently no custom rules disabled
- Use `// ignore: lint_rule_name` for suppressing specific warnings on lines/files

## External Dependencies

### Current Dependencies
- **flutter** (SDK) - Core Flutter framework
- **cupertino_icons** (v1.0.8) - iOS-style icons

### Dev Dependencies
- **flutter_lints** (v6.0.0) - Dart linter rules for Flutter
- **flutter_test** (SDK) - Testing framework

## Important Implementation Notes

### Hot Reload Behavior
- Hot reload preserves app state (e.g., counter value) during code changes
- Works for most code modifications but **not** for:
  - Changes to `main()` function or top-level variables
  - Structural changes to State classes
  - In these cases, use hot restart (`R`) instead

### Flutter Project Layout
This follows Flutter's standard structure:
- Platform-specific code isolated in `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`
- Shared Dart code in `lib/`
- Tests in `test/`
- Platform build/config files should rarely need modification for feature work

### Future Expansion Areas
- Plan UI components in `lib/widgets/` or `lib/screens/` subdirectories
- Create `lib/models/` for data classes and business logic
- Use `lib/services/` for API clients and external integrations
- Keep platform-specific code minimal; prefer Dart implementations

## Debugging & Troubleshooting

- Run with verbose output: `flutter run -v`
- Check device logs: `flutter logs`
- Restart Flutter daemon if cache issues: `flutter clean` then `flutter pub get`
- Verify environment setup: `flutter doctor`
