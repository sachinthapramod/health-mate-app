# HealthMate - Release Guide

## Pre-Release Checklist

- [x] All features implemented and tested
- [x] Core library desugaring enabled
- [x] Android permissions configured
- [x] App version set in pubspec.yaml
- [ ] Release signing key configured (for production)
- [ ] App tested on physical device
- [ ] All screens working correctly

## Building Release APK

### 1. Build Release APK

```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 2. Build Split APKs (Recommended for Play Store)

This creates separate APKs for different architectures (smaller file size):

```bash
flutter build apk --split-per-abi --release
```

This generates:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### 3. Build App Bundle (For Google Play Store)

For publishing to Google Play Store, use App Bundle:

```bash
flutter build appbundle --release
```

The AAB file will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

## Release Signing (Production)

### Generate Keystore

1. Create a keystore file:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:

```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the keystore file>
```

### Configure Signing in build.gradle.kts

Update `android/app/build.gradle.kts`:

```kotlin
// Add at the top
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// In android block, update buildTypes:
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug") // Remove this for production
        // Use this for production:
        // signingConfig = signingConfigs.getByName("release")
    }
}

// Add before buildTypes:
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}
```

## Version Management

### Update Version in pubspec.yaml

```yaml
version: 1.0.0+1
```

Format: `version_name+build_number`
- `1.0.0` = Version name (shown to users)
- `1` = Build number (incremented for each release)

### Update Version Code

Increment the build number for each release:
- First release: `1.0.0+1`
- Bug fix: `1.0.0+2`
- Minor update: `1.0.1+3`
- Major update: `2.0.0+4`

## Testing Release Build

### Install on Device

```bash
# Build and install
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk

# Or use flutter install
flutter install --release
```

### Test Checklist

- [ ] App launches without crashes
- [ ] All navigation works
- [ ] Database operations work
- [ ] Notifications work (if enabled)
- [ ] All screens load correctly
- [ ] Charts display properly
- [ ] BMI calculator works
- [ ] Settings save correctly

## Release Notes Template

```
HealthMate v1.0.0

Features:
- Track daily health metrics (steps, calories, water)
- Weekly summary with interactive charts
- BMI calculator with history
- Daily health reminders
- Water intake reminders
- Dark mode support
- Material 3 design

Bug Fixes:
- Fixed navigation issues
- Improved chart performance
```

## Publishing to Google Play Store

1. **Create App Listing**
   - App name: HealthMate
   - Short description: Personal Health Tracker
   - Full description: (Use features from README)
   - Screenshots: Take from app
   - App icon: Use launcher icon

2. **Upload AAB**
   - Use `app-release.aab` from build
   - Complete store listing
   - Set pricing (Free)
   - Submit for review

3. **Content Rating**
   - Complete content rating questionnaire
   - Health & Fitness category

## File Sizes

- Full APK: ~15-20 MB
- Split APK (per ABI): ~5-8 MB each
- App Bundle: ~10-15 MB (optimized by Play Store)

## Troubleshooting

### Build Fails

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Signing Issues

- Verify `key.properties` file exists
- Check keystore password is correct
- Ensure keystore file path is correct

### Large APK Size

- Use `--split-per-abi` for smaller APKs
- Use App Bundle for Play Store (automatic optimization)
- Check for unused assets/images

## Current Configuration

- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest (from Flutter)
- **Compile SDK**: Latest (from Flutter)
- **Java Version**: 11
- **Core Library Desugaring**: Enabled

## Quick Release Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build split APKs
flutter build apk --split-per-abi --release
```

## Next Steps After Release

1. Monitor crash reports (Firebase Crashlytics)
2. Collect user feedback
3. Plan next version features
4. Update documentation
5. Create changelog

---

**Ready to release!** 🚀

