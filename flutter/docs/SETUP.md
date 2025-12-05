# Platform Setup Guide

This guide helps you run Cashlens on different platforms (Windows, Android, iOS, Web).

## Prerequisites

- Flutter SDK 3.38.3 or higher
- Dart 3.10.1 or higher

## Platform-Specific Setup

### ✅ Web (Chrome)

**Requirements**: Chrome browser

**Run**:
```bash
flutter run -d chrome
```

**Build**:
```bash
flutter build web --release
```

---

### 🪟 Windows

**Requirements**:
- Visual Studio 2022 with "Desktop development with C++" workload
- Windows 10 SDK

**Setup**:
1. Install Visual Studio 2022 Community Edition
2. During installation, select "Desktop development with C++"
3. Ensure Windows 10 SDK is installed

**Run**:
```bash
flutter run -d windows
```

**Build**:
```bash
flutter build windows --release
```

**Common Issues**:

❌ **Error: "CMake not found"**
- Install Visual Studio with C++ workload
- Run `flutter doctor` to verify

❌ **Error: "Windows SDK not found"**
- Install Windows 10 SDK via Visual Studio Installer
- Restart Android Studio/VS Code

❌ **Error: "MSBuild not found"**
- Add Visual Studio to PATH:
  ```
  C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin
  ```

---

### 🤖 Android

**Requirements**:
- Android Studio
- Android SDK (API 21+)
- Android Emulator or physical device

**Setup**:
1. Install Android Studio
2. Install Android SDK via SDK Manager
3. Create an Android Virtual Device (AVD) or connect physical device
4. Enable USB debugging on physical device

**Run**:
```bash
# List devices
flutter devices

# Run on emulator
flutter run

# Run on specific device
flutter run -d <device-id>
```

**Build**:
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

**Common Issues**:

❌ **Error: "Android SDK not found"**
- Open Android Studio → Settings → Appearance & System Settings → Android SDK
- Note the SDK location
- Run: `flutter config --android-sdk <path-to-sdk>`

❌ **Error: "Gradle build failed"**
- Check `android/app/build.gradle.kts` has correct minSdk (21)
- Clear cache: `flutter clean && flutter pub get`
- Rebuild: `cd android && ./gradlew clean`

❌ **Error: "Unable to locate adb"**
- Add Android SDK platform-tools to PATH:
  ```
  C:\Users\<YourName>\AppData\Local\Android\Sdk\platform-tools
  ```

❌ **Error: "Execution failed for task ':app:processDebugMainManifest'"**
- Check AndroidManifest.xml for syntax errors
- Ensure all required permissions are declared

❌ **Error: "Emulator not starting"**
- Enable Virtualization (VT-x/AMD-V) in BIOS
- Install Intel HAXM or use ARM emulator
- Check Hyper-V is disabled (Windows)

---

### 🍎 iOS (macOS only)

**Requirements**:
- macOS
- Xcode 14+
- CocoaPods

**Setup**:
```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

**Run**:
```bash
# Simulator
flutter run -d ios

# Physical device
flutter run -d <device-id>
```

**Build**:
```bash
flutter build ios --release
```

---

## Troubleshooting

### General Issues

**❌ "Waiting for another flutter command to release the startup lock"**
```bash
# Delete lock file
rm -rf <flutter-sdk>/bin/cache/lockfile
```

**❌ "Pub get failed"**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**❌ "Hot reload not working"**
- Restart the app: Press `R` in terminal
- Full restart: Press `Shift + R`
- Restart IDE

### Platform Detection

Check which platforms are available:
```bash
flutter doctor -v
```

Check connected devices:
```bash
flutter devices
```

### Build Issues

**Clean and rebuild**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

**Clear all caches**:
```bash
flutter clean
flutter pub cache clean
rm -rf build/
rm -rf .dart_tool/
flutter pub get
```

## Development Tips

### Hot Reload
- Save file: Automatic hot reload
- Press `r`: Manual hot reload
- Press `R`: Hot restart (resets state)
- Press `q`: Quit

### Debug Mode
```bash
flutter run --debug
```

### Profile Mode (performance testing)
```bash
flutter run --profile
```

### Release Mode
```bash
flutter run --release
```

### Verbose Output
```bash
flutter run -v
```

## Platform-Specific Features

### Android
- **Permissions**: Declared in `android/app/src/main/AndroidManifest.xml`
- **Icons**: Located in `android/app/src/main/res/mipmap-*/`
- **Splash**: Configured in `android/app/src/main/res/drawable/launch_background.xml`

### Windows
- **App Name**: Set in `windows/runner/main.cpp`
- **Icon**: `windows/runner/resources/app_icon.ico`
- **Minimum Windows**: Windows 10

### iOS
- **Permissions**: Declared in `ios/Runner/Info.plist`
- **Icons**: Located in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **Minimum iOS**: iOS 12.0

### Web
- **Title**: Set in `web/index.html`
- **Icons**: Located in `web/icons/`
- **Manifest**: `web/manifest.json`

## Getting Help

If you encounter issues:

1. Run `flutter doctor -v` and check for issues
2. Check the error message carefully
3. Search Flutter GitHub issues: https://github.com/flutter/flutter/issues
4. Check Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

## Useful Commands

```bash
# Check Flutter installation
flutter doctor -v

# List all devices
flutter devices

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Update Flutter
flutter upgrade

# Check for outdated packages
flutter pub outdated
```
