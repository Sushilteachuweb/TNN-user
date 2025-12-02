# Debugging Profile Fetch & Update Issues

## Quick Checklist

When profile data is not loading or updating, check these in order:

### 1. Check Cookie Storage
```dart
// Add this temporarily in your code to debug
final prefs = await SharedPreferences.getInstance();
final cookie = prefs.getString("cookie");
print("🍪 Stored cookie: $cookie");
```

**Expected:** Should see something like `connect.sid=s%3A...`
**If empty:** Cookie wasn't saved during login - check `Api_service.dart` verifyOtp method

### 2. Check API Response
Look for these console logs:

#### Successful Profile Fetch:
```
🍪 Cookie used for fetchProfile: connect.sid=...
📡 Response status: 200
📩 Response body: {"success":true,"user":{...}}
✅ User profile loaded successfully!
   Name: John Doe
   Email: john@example.com
   Phone: +1234567890
```

#### Failed Profile Fetch:
```
❌ No cookie found! User might not be logged in.
```
OR
```
❌ Unauthorized - Cookie might be expired or invalid
```
OR
```
❌ Server error: 500
```

### 3. Check Network Connection
```dart
// Test if API is reachable
try {
  final response = await http.get(
    Uri.parse("https://api.thenaukrimitra.com/api/user/get-profile"),
  );
  print("API reachable: ${response.statusCode}");
} catch (e) {
  print("Network error: $e");
}
```

### 4. Verify Profile Model Parsing
If API returns 200 but user is null:
```dart
// Check if JSON parsing is working
final data = json.decode(response.body);
print("Raw user data: ${data["user"]}");

// Try parsing manually
try {
  final user = ProfileModel.fromJson(data["user"]);
  print("Parsed user: ${user.fullName}");
} catch (e) {
  print("Parsing error: $e");
}
```

## Common Issues & Solutions

### Issue 1: "No cookie found"
**Cause:** Cookie not saved during login
**Solution:**
1. Check `Api_service.dart` line ~45
2. Verify `set-cookie` header is present in response
3. Ensure SharedPreferences is saving correctly

```dart
// In verifyOtp method
final rawCookie = response.headers['set-cookie'];
print("🍪 Raw cookie from server: $rawCookie");

if (rawCookie != null) {
  final pref = await SharedPreferences.getInstance();
  await pref.setString("cookie", rawCookie);
  print("✅ Cookie saved successfully");
}
```

### Issue 2: "Unauthorized - Cookie expired"
**Cause:** Session expired or cookie format changed
**Solution:**
1. Clear app data and login again
2. Check if backend changed cookie format
3. Verify cookie is being sent correctly in headers

```dart
// Debug cookie in request
print("📤 Sending cookie: $cookie");
print("📤 Full headers: ${request.headers}");
```

### Issue 3: Profile loads but doesn't update
**Cause:** Update API not returning updated data
**Solution:**
1. Check update API response
2. Verify `fetchProfile()` is called after update
3. Check if `notifyListeners()` is called

```dart
// In updateProfile method
if (response.statusCode == 200) {
  print("✅ Update successful");
  await fetchProfile(); // ← Make sure this is called
  notifyListeners(); // ← And this
}
```

### Issue 4: Profile shows old data after update
**Cause:** UI not rebuilding or cache issue
**Solution:**
1. Ensure ProfileScreen uses `Consumer<ProfileProvider>`
2. Force rebuild after update
3. Clear any local caching

```dart
// In ProfileScreen
Consumer<ProfileProvider>(
  builder: (context, provider, child) {
    final profile = provider.user;
    return Text(profile?.fullName ?? "Loading...");
  },
)
```

### Issue 5: "Backend Error: role=user"
**Cause:** Database has incorrect user role
**Solution:** Contact backend team to fix user role in database

## Testing Commands

### Test Profile Fetch
```bash
# Using curl (replace cookie with actual value)
curl -X GET "https://api.thenaukrimitra.com/api/user/get-profile" \
  -H "Cookie: connect.sid=YOUR_COOKIE_HERE" \
  -H "Accept: application/json"
```

### Test Profile Update
```bash
curl -X PUT "https://api.thenaukrimitra.com/api/user/update-profile" \
  -H "Cookie: connect.sid=YOUR_COOKIE_HERE" \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test User","email":"test@example.com","gender":"male","education":"Graduate"}'
```

## Enable Detailed Logging

Add this to your `main.dart` for more detailed HTTP logs:

```dart
import 'package:http/http.dart' as http;

class LoggingClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print('📤 ${request.method} ${request.url}');
    print('📤 Headers: ${request.headers}');
    
    final response = await _inner.send(request);
    
    print('📥 Status: ${response.statusCode}');
    return response;
  }
}

// Use it in your API calls
final client = LoggingClient();
final response = await client.get(url, headers: headers);
```

## Quick Fix Checklist

- [ ] Cookie is saved after login
- [ ] Cookie is retrieved before API calls
- [ ] API returns 200 status
- [ ] Response has `success: true`
- [ ] Response has `user` object
- [ ] ProfileModel.fromJson() doesn't throw error
- [ ] `notifyListeners()` is called after data changes
- [ ] UI uses `Consumer` or `Provider.of` with `listen: true`
- [ ] `fetchProfile()` is called on app start
- [ ] `fetchProfile()` is called after profile update

## Still Not Working?

1. **Clear app data completely**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check backend API directly** using Postman or curl

3. **Add breakpoints** in:
   - `ProfileProvider.fetchProfile()` line 1
   - `ProfileProvider.updateProfile()` line 1
   - `ProfileScreen.initState()` line 1

4. **Check Flutter version compatibility**
   ```bash
   flutter doctor -v
   ```

5. **Verify dependencies are up to date**
   ```bash
   flutter pub upgrade
   ```
