# Profile Feature Testing Checklist

## Pre-Testing Setup

1. **Enable Debug Logging**
   - Open Android Studio / VS Code
   - Run app in debug mode
   - Open Debug Console to see logs

2. **Clear Previous Data** (Optional - for clean test)
   ```bash
   # Android
   flutter run --clear-cache
   
   # Or manually clear app data from device settings
   ```

## Test Scenarios

### ✅ Scenario 1: New User Registration & Profile Creation

**Steps:**
1. Launch app
2. Enter phone number: `+91XXXXXXXXXX`
3. Click "Send OTP"
4. Enter OTP received
5. Click "Verify Phone Number"
6. Fill profile creation form:
   - Full Name
   - Gender
   - Education
   - Job Category
   - Experience details
7. Click "Submit"

**Expected Results:**
- [ ] OTP sent successfully
- [ ] OTP verified successfully
- [ ] Navigates to CreateProfile screen
- [ ] Profile created successfully
- [ ] Navigates to MainScreen/HomeScreen
- [ ] Console shows: `✅ User profile loaded successfully!`

**Console Logs to Check:**
```
🍪 Cookie saved: connect.sid=...
✅ Profile created successfully
🍪 Cookie used for fetchProfile: connect.sid=...
📡 Response status: 200
✅ User profile loaded successfully!
   Name: [Your Name]
   Email: [Your Email]
   Phone: [Your Phone]
```

---

### ✅ Scenario 2: Existing User Login

**Steps:**
1. Launch app
2. Enter existing user phone number
3. Click "Send OTP"
4. Enter OTP
5. Click "Verify Phone Number"

**Expected Results:**
- [ ] OTP verified successfully
- [ ] Directly navigates to MainScreen (skips CreateProfile)
- [ ] Profile data loads automatically
- [ ] Console shows profile fetch logs

**Console Logs to Check:**
```
🍪 Cookie saved: connect.sid=...
✅ Existing user detected
🍪 Cookie used for fetchProfile: connect.sid=...
📡 Response status: 200
✅ User profile loaded successfully!
```

---

### ✅ Scenario 3: View Profile

**Steps:**
1. Login as existing user
2. Navigate to "Profile" tab (bottom navigation)
3. Wait for profile to load

**Expected Results:**
- [ ] Profile screen shows loading indicator initially
- [ ] Profile data appears after loading:
  - Profile picture (if uploaded)
  - Full name
  - Phone number
  - Email
  - Gender
  - Education
  - Work experience
  - Skills
  - Resume (if uploaded)

**Console Logs to Check:**
```
🍪 Cookie used for fetchProfile: connect.sid=...
📡 Response status: 200
📩 Response body: {"success":true,"user":{...}}
✅ User profile loaded successfully!
```

---

### ✅ Scenario 4: Update Profile (Text Fields Only)

**Steps:**
1. Go to Profile screen
2. Click edit icon (pencil icon)
3. Update profile sheet appears
4. Modify:
   - Full Name: "Updated Name"
   - Email: "newemail@example.com"
   - Gender: Select different option
   - Education: "Post Graduate"
5. Click "Save Changes"

**Expected Results:**
- [ ] Loading indicator shows during update
- [ ] Success message: "Profile updated successfully ✅"
- [ ] Bottom sheet closes
- [ ] Profile screen refreshes with new data
- [ ] Updated values are visible

**Console Logs to Check:**
```
🍪 Cookie used for updateProfile: connect.sid=...
📤 Updating profile with:
   Name: Updated Name
   Email: newemail@example.com
   Gender: male
   Education: Post Graduate
📡 Sending update request...
📡 Update response status: 200
✅ Profile updated successfully!
🍪 Cookie used for fetchProfile: connect.sid=...
✅ User profile loaded successfully!
```

---

### ✅ Scenario 5: Update Profile with Image & Resume

**Steps:**
1. Go to Profile screen
2. Click edit icon
3. Click "Profile Image (Optional)"
4. Select an image from gallery
5. Click "Resume (Optional)"
6. Select a PDF/document
7. Update other fields if needed
8. Click "Save Changes"

**Expected Results:**
- [ ] Image preview shows selected image
- [ ] Resume filename shows selected file
- [ ] Update succeeds
- [ ] Profile picture updates on profile screen
- [ ] Resume link/name appears

**Console Logs to Check:**
```
🖼️ Profile image added
📄 Resume file added
📡 Update response status: 200
✅ Profile updated successfully!
```

---

### ✅ Scenario 6: App Restart - Profile Persistence

**Steps:**
1. Login and view profile
2. Close app completely (kill from recent apps)
3. Reopen app

**Expected Results:**
- [ ] App opens directly to MainScreen (doesn't ask for login)
- [ ] Profile data loads automatically
- [ ] All profile information is still present

**Console Logs to Check:**
```
🍪 Cookie used for fetchProfile: connect.sid=...
✅ User profile loaded successfully!
```

---

### ✅ Scenario 7: Network Error Handling

**Steps:**
1. Turn off WiFi/Mobile data
2. Try to view profile
3. Turn on network
4. Pull to refresh or navigate away and back

**Expected Results:**
- [ ] Shows appropriate error message
- [ ] Doesn't crash
- [ ] Recovers when network is restored

**Console Logs to Check:**
```
❌ Fetch profile error: SocketException: ...
```

---

### ✅ Scenario 8: Session Expiry

**Steps:**
1. Login successfully
2. Wait for session to expire (or manually clear cookie)
3. Try to fetch/update profile

**Expected Results:**
- [ ] Shows unauthorized error
- [ ] Redirects to login screen (if implemented)
- [ ] Doesn't crash

**Console Logs to Check:**
```
❌ Unauthorized - Cookie might be expired or invalid
```

---

## Error Scenarios to Test

### ❌ Test 1: Invalid OTP
- Enter wrong OTP
- Should show error message
- Should not navigate forward

### ❌ Test 2: Empty Profile Fields
- Try to update profile with empty required fields
- Should show validation errors
- Should not submit

### ❌ Test 3: Invalid Email Format
- Enter invalid email (e.g., "notanemail")
- Should show validation error

### ❌ Test 4: Network Timeout
- Use slow/unstable network
- Should handle gracefully
- Should show loading indicator

---

## Performance Checks

- [ ] Profile loads within 2-3 seconds
- [ ] No UI freezing during API calls
- [ ] Smooth navigation between screens
- [ ] No memory leaks (check with Flutter DevTools)

---

## Regression Testing

After fixes, verify these still work:

- [ ] Job listing still loads
- [ ] Job search works
- [ ] Job application works
- [ ] Video section works
- [ ] My Activity section works
- [ ] Bottom navigation works
- [ ] Back button behavior is correct

---

## Sign-Off

**Tested By:** _______________
**Date:** _______________
**Device:** _______________
**OS Version:** _______________
**App Version:** _______________

**Overall Status:**
- [ ] All tests passed
- [ ] Some tests failed (list below)
- [ ] Needs more investigation

**Failed Tests:**
1. 
2. 
3. 

**Notes:**


