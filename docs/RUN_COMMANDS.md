# HealthMate - Run Commands

## Quick Run Commands

### Run on Connected Device/Emulator
```bash
flutter run
```
This will automatically detect and run on the first available device/emulator.

### Run on Specific Device
```bash
# List all available devices
flutter devices

# Run on specific device (use device ID from flutter devices)
flutter run -d <device-id>

# Example:
flutter run -d emulator-5554
```

### Run in Release Mode
```bash
flutter run --release
```
Runs the app in release mode (optimized, no debug features).

### Run in Profile Mode
```bash
flutter run --profile
```
Runs the app in profile mode (for performance testing).

## Common Commands

### Check Available Devices
```bash
flutter devices
```

### List Emulators
```bash
flutter emulators
```

### Launch Emulator
```bash
flutter emulators --launch <emulator-id>
```

### Hot Reload (while app is running)
Press `r` in the terminal where `flutter run` is active.

### Hot Restart (while app is running)
Press `R` (capital R) in the terminal.

### Quit App
Press `q` in the terminal.

## Build Commands

### Build APK (Android)
```bash
flutter build apk
```
Creates: `build/app/outputs/flutter-apk/app-release.apk`

### Build APK (Debug)
```bash
flutter build apk --debug
```

### Build APK (Split by ABI - smaller file)
```bash
flutter build apk --split-per-abi
```

### Build App Bundle (for Play Store)
```bash
flutter build appbundle
```

### Build iOS (macOS only)
```bash
flutter build ios
```

## Troubleshooting Commands

### Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

### Check Flutter Setup
```bash
flutter doctor
```

### Get Dependencies
```bash
flutter pub get
```

## Example Workflow

```bash
# 1. Check devices
flutter devices

# 2. If no emulator, start one
flutter emulators --launch <emulator-id>

# 3. Get dependencies (if needed)
flutter pub get

# 4. Run the app
flutter run

# 5. While running:
#    - Press 'r' for hot reload
#    - Press 'R' for hot restart
#    - Press 'q' to quit
```

