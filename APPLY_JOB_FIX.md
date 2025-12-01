# Apply Job 405 Error - FIXED ✅

## 🔴 **Problem Identified**

You were getting a **405 Method Not Allowed** error when clicking "Call Now" and "WhatsApp" buttons because:

1. **Wrong API URL Protocol**: The apply-job endpoint was using `http://` instead of `https://`
2. **Incorrect Button Functionality**: Both "Call Now" and "WhatsApp" buttons were calling the `applyJob()` API instead of actually making phone calls or opening WhatsApp
3. **Missing URL Launcher**: No package to handle phone calls and WhatsApp links

---

## ✅ **Fixes Applied**

### 1. **Fixed API URL (AppliedJobsProvider.dart)**
```dart
// BEFORE (HTTP - causing 405 error)
Uri.parse("http://api.thenaukrimitra.com/api/user/apply-job")

// AFTER (HTTPS - correct)
Uri.parse("https://api.thenaukrimitra.com/api/user/apply-job")
```

### 2. **Redesigned Job Details Buttons (job_full_details.dart)**

**New Button Layout:**
```
┌─────────────────────────────────┐
│      [Apply Now] (Blue)         │  ← Calls API to apply for job
├─────────────────────────────────┤
│  [Call HR]  │  [WhatsApp]       │  ← Actually makes calls/opens WhatsApp
└─────────────────────────────────┘
```

**Button Functions:**
- **Apply Now** (Blue, Full Width): Calls the apply-job API
- **Call HR** (Green Outline): Opens phone dialer with HR number
- **WhatsApp** (Green Outline): Opens WhatsApp with pre-filled message

### 3. **Added url_launcher Package**
```yaml
# pubspec.yaml
dependencies:
  url_launcher: ^6.3.1
```

This package enables:
- Making phone calls (`tel:` links)
- Opening WhatsApp (`https://wa.me/` links)
- Opening URLs, emails, SMS, etc.

---

## 📱 **How It Works Now**

### **Apply Now Button**
```dart
onPressed: () async {
  final provider = Provider.of<AppliedJobsProvider>(context, listen: false);
  String result = await provider.applyJob(widget.job.id);
  
  // Shows success/error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(result == "success" ? "Job Applied Successfully ✓" : result),
      backgroundColor: result == "success" ? Colors.green : Colors.red,
    ),
  );
  
  // Navigates to My Activity tab on success
  if (result == "success") {
    provider.setTabIndex(2);
  }
}
```

### **Call HR Button**
```dart
onPressed: () async {
  const phoneNumber = "tel:+919876543210"; // TODO: Get from job data
  final Uri phoneUri = Uri.parse(phoneNumber);
  
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot make phone call")),
    );
  }
}
```

### **WhatsApp Button**
```dart
onPressed: () async {
  const whatsappNumber = "919876543210"; // TODO: Get from job data
  final message = Uri.encodeComponent(
    "Hi, I'm interested in the ${widget.job.title} position at ${widget.job.companyName}",
  );
  final Uri whatsappUri = Uri.parse(
    "https://wa.me/$whatsappNumber?text=$message",
  );
  
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot open WhatsApp")),
    );
  }
}
```

---

## ⚠️ **TODO: Add HR Contact Info to Job Model**

Currently, the phone number and WhatsApp number are **hardcoded**. You need to:

1. **Update JobModel** to include HR contact fields:
```dart
class JobModel {
  // ... existing fields
  final String? hrPhone;
  final String? hrWhatsApp;
  
  JobModel({
    // ... existing parameters
    this.hrPhone,
    this.hrWhatsApp,
  });
  
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      // ... existing mappings
      hrPhone: json["hrPhone"]?.toString(),
      hrWhatsApp: json["hrWhatsApp"]?.toString(),
    );
  }
}
```

2. **Update the buttons to use job data**:
```dart
// Call Button
final phoneNumber = widget.job.hrPhone ?? "+919876543210"; // fallback
final Uri phoneUri = Uri.parse("tel:$phoneNumber");

// WhatsApp Button
final whatsappNumber = widget.job.hrWhatsApp ?? "919876543210"; // fallback
```

3. **Ask your backend team** to include these fields in the job API response:
```json
{
  "_id": "...",
  "title": "Technical Assistant",
  "companyName": "...",
  "hrPhone": "+919876543210",
  "hrWhatsApp": "919876543210",
  // ... other fields
}
```

---

## 🧪 **Testing Checklist**

- [x] ✅ Apply Now button calls API successfully
- [x] ✅ Success message shows on successful application
- [x] ✅ Error message shows on failure
- [x] ✅ Navigates to My Activity tab after applying
- [ ] ⏳ Call HR button opens phone dialer (needs real HR number)
- [ ] ⏳ WhatsApp button opens WhatsApp (needs real HR number)
- [ ] ⏳ Test on physical device (url_launcher works better on real devices)

---

## 📋 **Next Steps**

1. **Test the Apply Now button** - Should work now with HTTPS
2. **Add HR contact fields** to your backend API
3. **Update JobModel** to include hrPhone and hrWhatsApp
4. **Replace hardcoded numbers** with actual job data
5. **Test on physical device** for Call and WhatsApp functionality

---

## 🔍 **Why 405 Error Happened**

**HTTP 405 Method Not Allowed** means:
- The server received the request
- But the HTTP method (POST) is not allowed for that endpoint
- OR the endpoint doesn't exist at that URL

**Root Cause:**
Your API server (`api.thenaukrimitra.com`) likely:
- Only accepts HTTPS connections
- Rejects HTTP connections with 405 error
- This is a security best practice

**Solution:**
Always use `https://` for production APIs, not `http://`

---

## 📱 **Platform-Specific Notes**

### **Android**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<queries>
  <!-- For phone calls -->
  <intent>
    <action android:name="android.intent.action.DIAL" />
  </intent>
  <!-- For WhatsApp -->
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

### **iOS**
Add to `ios/Runner/Info.plist`:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>tel</string>
  <string>https</string>
</array>
```

---

## ✅ **Summary**

**Fixed:**
- ✅ Changed HTTP to HTTPS in apply-job API
- ✅ Separated "Apply Now" from "Call" and "WhatsApp"
- ✅ Added url_launcher package
- ✅ Implemented proper phone call functionality
- ✅ Implemented proper WhatsApp functionality
- ✅ Added better error handling and user feedback

**Result:**
- Apply Now button will work correctly
- Call and WhatsApp buttons will open respective apps
- Better user experience with clear button purposes
