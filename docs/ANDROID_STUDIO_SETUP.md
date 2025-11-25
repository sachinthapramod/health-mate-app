# Running HealthMate in Android Studio

> **Mobile-Only App:** This app is configured for Android and iOS platforms only. Web support is disabled.

## Prerequisites

1. **Android Studio** (latest version recommended)
   - Download from: https://developer.android.com/studio
   - Install Flutter and Dart plugins:
     - Go to `File` → `Settings` → `Plugins`
     - Search for "Flutter" and install
     - Search for "Dart" and install (usually installed with Flutter)

2. **Flutter SDK** (3.24 or higher)
   - Verify installation: Open terminal and run `flutter --version`
   - If not installed, follow: https://docs.flutter.dev/get-started/install

3. **Android SDK**
   - Android Studio will prompt to install during setup
   - Or install via `Tools` → `SDK Manager` in Android Studio

## Step-by-Step Setup

### 1. Open the Project

1. Launch **Android Studio**
2. Click **"Open"** or **"File" → "Open"**
3. Navigate to the project folder: `C:\Users\sachi\Documents\GitHub\health-mate-app`
4. Select the folder and click **"OK"**
5. Android Studio will detect it's a Flutter project and index files

### 2. Configure Flutter SDK (if needed)

1. Go to **"File" → "Settings"** (or **"Preferences"** on Mac)
2. Navigate to **"Languages & Frameworks" → "Flutter"**
3. Set the **Flutter SDK path** (e.g., `C:\flutter` or wherever Flutter is installed)
4. Click **"Apply"** and **"OK"**

### 3. Get Dependencies

1. Open the terminal in Android Studio: **"View" → "Tool Windows" → "Terminal"**
2. Run:
   ```bash
   flutter pub get
   ```
   This installs all required packages from `pubspec.yaml`

### 4. Set Up Android Emulator

#### Option A: Create a New Emulator

1. Click **"Device Manager"** icon in the toolbar (or **"Tools" → "Device Manager"**)
2. Click **"Create Device"**
3. Select a device (e.g., **"Pixel 5"**)
4. Click **"Next"**
5. Select a system image (e.g., **"API 33"** or latest)
   - If not installed, click **"Download"** next to the system image
6. Click **"Next"** → **"Finish"**

#### Option B: Use Physical Device

1. Enable **Developer Options** on your Android phone:
   - Go to **Settings** → **About Phone**
   - Tap **"Build Number"** 7 times
2. Enable **USB Debugging**:
   - Go to **Settings** → **Developer Options**
   - Toggle **"USB Debugging"** ON
3. Connect phone via USB
4. Accept the USB debugging prompt on your phone

### 5. Verify Setup

1. In the terminal, run:
   ```bash
   flutter doctor
   ```
2. Check that all items show green checkmarks (✓)
   - If there are issues, follow the suggested fixes

### 6. Run the App

#### Method 1: Using Run Button

1. Select your device/emulator from the device dropdown (top toolbar)
2. Click the **green "Run"** button (▶) or press **Shift + F10**
3. Wait for the app to build and launch

#### Method 2: Using Terminal

1. Open terminal in Android Studio
2. Run:
   ```bash
   flutter run
   ```
3. If multiple devices are connected, select one when prompted

### 7. Hot Reload & Hot Restart

While the app is running:
- **Hot Reload**: Press **Ctrl + \** (or click the 🔥 icon)
  - Applies code changes instantly without restarting
- **Hot Restart**: Press **Ctrl + Shift + \** (or click the 🔄 icon)
  - Restarts the app with latest changes

## Troubleshooting

### Issue: "No devices found"

**Solution:**
- Make sure an emulator is running or a device is connected
- Check device connection: `flutter devices` in terminal
- Restart Android Studio

### Issue: "Gradle build failed"

**Solution:**
1. Go to **"File" → "Invalidate Caches" → "Invalidate and Restart"**
2. Or run in terminal:
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

### Issue: "SDK location not found"

**Solution:**
1. Create `local.properties` file in `android/` folder
2. Add:
   ```
   sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk
   ```
   (Replace with your actual SDK path)

### Issue: "Flutter plugin not installed"

**Solution:**
1. Go to **"File" → "Settings" → "Plugins"**
2. Search for "Flutter"
3. Install and restart Android Studio

### Issue: Build errors

**Solution:**
1. Run `flutter clean` in terminal
2. Run `flutter pub get`
3. Restart Android Studio
4. Try building again

## Building APK

To create an APK file:

1. Open terminal in Android Studio
2. Run:
   ```bash
   flutter build apk
   ```
3. APK will be at: `build\app\outputs\flutter-apk\app-release.apk`

For debug APK:
```bash
flutter build apk --debug
```

## Useful Android Studio Features

1. **Flutter Inspector**: View widget tree and properties
   - **"View" → "Tool Windows" → "Flutter Inspector"**

2. **Debug Console**: View logs and errors
   - **"View" → "Tool Windows" → "Debug"**

3. **Run Configuration**: Customize run settings
   - Click dropdown next to Run button → **"Edit Configurations"**

4. **Code Formatting**: Auto-format code
   - Right-click file → **"Reformat Code"** or **Ctrl + Alt + L**

## Quick Start Checklist

- [ ] Android Studio installed
- [ ] Flutter and Dart plugins installed
- [ ] Flutter SDK configured
- [ ] Project opened in Android Studio
- [ ] `flutter pub get` executed
- [ ] Emulator created or device connected
- [ ] `flutter doctor` shows no critical issues
- [ ] App runs successfully

## Next Steps

Once the app is running:
- Try adding a health record
- View the dashboard
- Test search/filter functionality
- Test update and delete operations

Happy coding! 🚀

