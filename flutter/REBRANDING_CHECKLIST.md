# Rebranding Checklist: EMM-MoneyBox → Cashlens

This document tracks all rebranding changes from EMM-MoneyBox to Cashlens.

## ✅ Completed Changes

### Core Configuration
- [x] `pubspec.yaml` - Package name: `emm_moneybox` → `cashlens`
- [x] `pubspec.yaml` - Description updated with slogan
- [x] All Dart imports updated to use `package:cashlens/`

### Android Platform
- [x] `android/app/build.gradle.kts` - Package: `com.emm.emm_moneybox` → `com.cashlens.app`
- [x] `android/app/build.gradle.kts` - Namespace updated
- [x] `android/app/src/main/AndroidManifest.xml` - App label: `emm_moneybox` → `Cashlens`
- [x] `android/app/src/main/AndroidManifest.xml` - Added INTERNET permission
- [x] `android/app/src/main/kotlin/.../MainActivity.kt` - Package path moved and updated

### iOS Platform
- [x] `ios/Runner/Info.plist` - CFBundleDisplayName: `Emm Moneybox` → `Cashlens`
- [x] `ios/Runner/Info.plist` - CFBundleName: `emm_moneybox` → `cashlens`

### macOS Platform
- [x] `macos/Runner/Configs/AppInfo.xcconfig` - PRODUCT_NAME: `emm_moneybox` → `cashlens`
- [x] `macos/Runner.xcodeproj/project.pbxproj` - All references updated

### Windows Platform
- [x] `windows/CMakeLists.txt` - Project name: `emm_moneybox` → `cashlens`
- [x] `windows/CMakeLists.txt` - BINARY_NAME: `emm_moneybox` → `cashlens`
- [x] `windows/runner/main.cpp` - Window title: `emm_moneybox` → `Cashlens`

### Linux Platform
- [x] `linux/CMakeLists.txt` - BINARY_NAME: `emm_moneybox` → `cashlens`
- [x] `linux/CMakeLists.txt` - APPLICATION_ID: `com.emm.emm_moneybox` → `com.cashlens.app`
- [x] `linux/runner/my_application.cc` - Header bar title updated
- [x] `linux/runner/my_application.cc` - Window title updated

### Web Platform
- [x] `web/index.html` - Title: `emm_moneybox` → `Cashlens - See your money clearly`
- [x] `web/index.html` - Meta description updated
- [x] `web/index.html` - Apple mobile web app title updated
- [x] `web/manifest.json` - Name and short_name updated (auto-generated)

### IDE Configuration
- [x] `.idea/modules.xml` - Module references updated
- [x] `emm_moneybox.iml` → `cashlens.iml` (renamed)
- [x] `android/emm_moneybox_android.iml` → `android/cashlens_android.iml` (renamed)

### Application Code
- [x] `lib/shared/constants/app_constants.dart` - appName: `EMM MoneyBox` → `Cashlens`
- [x] `lib/shared/constants/app_constants.dart` - Added appSlogan
- [x] `lib/features/dashboard/presentation/dashboard_screen.dart` - UI text updated
- [x] `lib/features/auth/presentation/landing_page.dart` - UI text updated

### Documentation
- [x] Root `README.md` - Project name and description
- [x] Root `TODO.md` - Project name
- [x] `flutter/README.md` - Project name and description
- [x] Backend `util/config_util.go` - Log file name: `emm-moneybox.log` → `cashlens.log`
- [x] Backend `util/config_util.go` - Database name: `emm_moneybox` → `cashlens`

### Environment Configuration
- [x] `.env.sample` - Updated with Cashlens branding
- [x] `ENVIRONMENT.md` - Created with configuration guide

## Verification Commands

Run these commands to verify no old references remain:

```bash
# Search for old package name
grep -r "emm_moneybox" --include="*.dart" --include="*.yaml" --include="*.kt" --include="*.swift" --include="*.cpp" --include="*.cc" --include="*.xml" --include="*.plist" . | grep -v ".dart_tool" | grep -v "build/"

# Search for old organization
grep -r "com\.emm\." --include="*.kt" --include="*.xml" . | grep -v ".dart_tool" | grep -v "build/"

# Search for old display name
grep -r "EMM" --include="*.dart" --include="*.xml" --include="*.plist" . | grep -v ".dart_tool" | grep -v "build/" | grep -v "COMMENT"
```

## New Branding

**Name**: Cashlens  
**Slogan**: See your money clearly  
**Package**: `cashlens`  
**Organization**: `com.cashlens.app`  

## Platform-Specific Names

- **Android**: Cashlens (`com.cashlens.app`)
- **iOS**: Cashlens (`com.cashlens.app`)
- **macOS**: cashlens
- **Windows**: Cashlens (cashlens.exe)
- **Linux**: Cashlens (cashlens binary)
- **Web**: Cashlens

## Notes

- Generated files (`.xcconfig`, `.pbxproj`) may still contain old workspace paths - these are regenerated on build
- The workspace directory name `/workspaces/EMM-MoneyBox` is local and doesn't affect the app
- All user-facing names are now "Cashlens"
- All package identifiers use `com.cashlens.app`
- Database and log files use lowercase `cashlens`

## Testing

After rebranding, test on each platform:

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Test each platform
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d android       # Android
flutter run -d ios           # iOS (macOS only)
flutter run -d macos         # macOS (macOS only)
flutter run -d linux         # Linux
```

Verify:
- App name displays as "Cashlens" on all platforms
- Window/app titles show "Cashlens"
- Package identifiers are correct
- No build errors related to old names
