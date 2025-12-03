# Build Fix - Android SDK Version

## Issue:
The geocoding_android package requires Android SDK 34 or higher, but the project was compiled against SDK 33.

## Solution:
Updated `android/app/build.gradle.kts` to use:
- `compileSdk = 34` (was using flutter.compileSdkVersion which defaults to 33)
- `targetSdk = 34` (was using flutter.targetSdkVersion)

## Changes Made:
1. Set `compileSdk = 34` in android block
2. Set `targetSdk = 34` in defaultConfig block
3. Ran `flutter clean` to clear old build artifacts
4. Ran `flutter pub get` to refresh dependencies

## Next Steps:
Run `flutter run` to build and deploy the app to your device.

The location feature should now work properly with:
- Location permission dialog on app start
- GPS location fetching
- Address display in app bar header
