# Cookie Session Management Fix

## Issue Description

When a new user creates a profile, two cookies are generated:
1. **Cookie from OTP verification** - Generated when user verifies OTP
2. **Cookie from profile creation** - Generated when profile is created

The problem was that `fetchProfile()` was being called **before** the new cookie was saved, causing it to use the old cookie which resulted in "User session not found" error.

## Root Cause

```
Flow:
1. User verifies OTP → Cookie A saved
2. User creates profile → Cookie B generated
3. fetchProfile() called → Still using Cookie A ❌
4. API returns 400: "User session not found"
```

## Solution Applied

### 1. Fixed Cookie Save Order in CreateProfileProvider

**Before:**
```dart
Provider.of<ProfileProvider>(context, listen: false).fetchProfile(); // ❌ Called first
// ... later ...
await pref.setString("cookie", rawCookie); // ❌ Saved after
```

**After:**
```dart
// ✅ FIRST: Save the new cookie
final rawCookie = streamedResponse.headers['set-cookie'];
if (rawCookie != null) {
  final pref = await SharedPreferences.getInstance();
  await pref.setString("cookie", rawCookie);
  await Future.delayed(const Duration(milliseconds: 100)); // Ensure persistence
}

// ✅ THEN: Fetch profile with the new cookie
await Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
```

### 2. Added Nested Error Handling

The backend sometimes returns a confusing nested error structure:
```json
{
  "success": true,
  "message": "User profile created successfully",
  "data": {
    "success": false,
    "message": "This email is already registered"
  }
}
```

**Fix:** Check for `data.success` before proceeding:
```dart
if (data['data'] != null && data['data']['success'] == false) {
  return {
    "success": false,
    "message": data['data']['message'] ?? "Profile creation failed",
  };
}
```

## Testing

### Test Case 1: New User with Unique Email
```
Steps:
1. Login with new phone number
2. Verify OTP
3. Create profile with UNIQUE email
4. Check console logs

Expected:
✅ Cookie saved after OTP
✅ New cookie saved after profile creation
✅ Profile fetched successfully
✅ Navigate to next screen
```

### Test Case 2: Duplicate Email Error
```
Steps:
1. Login with new phone number
2. Verify OTP
3. Create profile with EXISTING email (e.g., "Ali@gmail.com")
4. Check error message

Expected:
❌ Error shown: "This email is already registered"
❌ Does not navigate forward
❌ User can correct email and retry
```

## Console Log Indicators

### Success Flow:
```
🍪 Cookie saved: connect.sid=s%3A[OTP_COOKIE]...
📤 Sending request to: https://api.thenaukrimitra.com/api/user/create
🔵 Status Code: 200
🟢 Raw Response: {"success":true,"message":"User profile created successfully",...}
🍪 New cookie saved after profile creation: connect.sid=s%3A[NEW_COOKIE]...
📡 Fetching profile with new cookie...
🍪 Cookie used for fetchProfile: connect.sid=s%3A[NEW_COOKIE]...
📡 Response status: 200
✅ User profile loaded successfully!
```

### Error Flow (Duplicate Email):
```
🔵 Status Code: 200
🟢 Raw Response: {"success":true,"data":{"success":false,"message":"This email is already registered"}}
❌ Backend returned nested error: This email is already registered. Please use a different email.
```

### Error Flow (Session Not Found):
```
🍪 Cookie used for fetchProfile: connect.sid=s%3A[OLD_COOKIE]...
📡 Response status: 400
📩 Response body: {"success":false,"message":"User session not found. Please login again."}
❌ Server error: 400
```

## Additional Recommendations

### 1. Use Dynamic Email Instead of Hardcoded

**Current (in CreateProfile.dart):**
```dart
email: "Ali@gmail.com", // ❌ Hardcoded
```

**Recommended:**
```dart
// Add email field in the form
final emailController = TextEditingController();

// In the form:
TextField(
  controller: emailController,
  decoration: InputDecoration(labelText: "Email"),
  keyboardType: TextInputType.emailAddress,
),

// When saving:
email: emailController.text.trim(),
```

### 2. Add Email Validation

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}
```

### 3. Handle Cookie Expiration

Add session timeout check:
```dart
static Future<bool> isSessionValid() async {
  final prefs = await SharedPreferences.getInstance();
  final cookie = prefs.getString("cookie");
  
  if (cookie == null || cookie.isEmpty) {
    return false;
  }
  
  // Check if cookie has expired
  // Parse Expires= from cookie string
  final expiresMatch = RegExp(r'Expires=([^;]+)').firstMatch(cookie);
  if (expiresMatch != null) {
    final expiresStr = expiresMatch.group(1);
    final expiresDate = DateTime.parse(expiresStr!);
    return DateTime.now().isBefore(expiresDate);
  }
  
  return true;
}
```

### 4. Clear Old Cookie Before Saving New One

```dart
// Before saving new cookie
final pref = await SharedPreferences.getInstance();
await pref.remove("cookie"); // Clear old cookie
await pref.setString("cookie", rawCookie); // Save new cookie
```

## Files Modified

1. `lib/provider/CreateProfileProvider.dart`
   - Reordered cookie save and profile fetch
   - Added nested error handling
   - Added cookie persistence delay
   - Added better logging

## Verification Steps

1. **Clear app data completely**
   ```bash
   flutter clean
   flutter run
   ```

2. **Test with new phone number and unique email**
   - Should create profile successfully
   - Should fetch profile without errors
   - Should navigate to next screen

3. **Test with duplicate email**
   - Should show error message
   - Should not navigate forward
   - Should allow user to retry

4. **Check console logs**
   - Verify new cookie is saved before fetchProfile
   - Verify fetchProfile uses the new cookie
   - Verify no 400 errors

## Known Issues

1. **Hardcoded email** - Currently using "Ali@gmail.com" which causes duplicate email errors
   - **Solution:** Add email input field in CreateProfile screen

2. **No email uniqueness check** - User doesn't know if email is taken until after submission
   - **Solution:** Add real-time email availability check

3. **Cookie format parsing** - Cookie string is not parsed, just stored as-is
   - **Solution:** Parse cookie to extract session ID and expiry

## Next Steps

1. ✅ Fix cookie save order (DONE)
2. ✅ Add nested error handling (DONE)
3. ⏳ Add email input field in CreateProfile
4. ⏳ Add email validation
5. ⏳ Add session timeout handling
6. ⏳ Add cookie expiry check
