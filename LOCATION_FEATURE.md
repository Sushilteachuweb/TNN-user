# Location Feature Implementation

## What was implemented:

1. **Location Permission Handling**
   - Added location permission request dialog when app opens
   - Checks if location services are enabled
   - Requests location permissions from user

2. **Location Fetching**
   - Fetches user's current location using GPS
   - Converts coordinates to readable address (city and area)
   - Displays location in the app bar header

3. **Location Display in App Bar**
   - Shows current city and area in the CustomHeader
   - Updates automatically when location is fetched
   - Shows loading indicator while fetching
   - Tap on location to refresh

## Files Modified/Created:

### New Files:
- `lib/Services/location_service.dart` - Handles location permissions and fetching
- `lib/provider/LocationProvider.dart` - Manages location state
- `lib/utils/location_permission_dialog.dart` - Shows permission dialog

### Modified Files:
- `pubspec.yaml` - Added geolocator and geocoding packages
- `lib/main.dart` - Added LocationProvider to app
- `lib/utils/custom_header.dart` - Updated to display fetched location
- `lib/Home_screens/home_screen.dart` - Added location fetch on init
- `android/app/src/main/AndroidManifest.xml` - Added location permissions
- `ios/Runner/Info.plist` - Added location usage descriptions

## How it works:

1. When app opens, HomeScreen checks location permission
2. If not enabled, shows dialog asking user to enable
3. Once enabled, fetches current location
4. Converts GPS coordinates to city/area name
5. Displays in app bar header
6. User can tap location to refresh

## Permissions Required:

### Android:
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION

### iOS:
- NSLocationWhenInUseUsageDescription
- NSLocationAlwaysUsageDescription
- NSLocationAlwaysAndWhenInUseUsageDescription
