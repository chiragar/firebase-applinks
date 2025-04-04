# Firebase App Links in Flutter (Post Firebase Dynamic Links Deprecation)

## Overview
With the deprecation of Firebase Dynamic Links, developers must use Firebase App Links with custom domain settings to handle deep linking. This guide provides a step-by-step approach to setting up Firebase App Links in Flutter.

## Prerequisites
- A Firebase project.
- A Flutter application.
- A configured custom domain (e.g., `yourdomain.com`).

## Setup Firebase App Links

### 1. Configure Firebase Hosting
To use Firebase App Links, you need Firebase Hosting for your domain.

- Go to [Firebase Console](https://console.firebase.google.com/).
- Select your project and navigate to **Hosting**.
- Set up a hosting site for your domain (e.g., `app.yourdomain.com`).
- Deploy a `firebase.json` file to configure deep linking.

### 2. Configure App Links on Android
Modify your `assetlinks.json` file for deep linking:

1. Create `/.well-known/assetlinks.json` on Firebase Hosting with the following content:

   ```json
   [
     {
       "relation": ["delegate_permission/common.handle_all_urls"],
       "target": {
         "namespace": "android_app",
         "package_name": "com.example.app",
         "sha256_cert_fingerprints": [
           "YOUR_APP_SHA256_CERT"
         ]
       }
     }
   ]
   ```

2. Modify `AndroidManifest.xml` to support deep linking:

   ```xml
   <intent-filter>
       <action android:name="android.intent.action.VIEW" />
       <category android:name="android.intent.category.DEFAULT" />
       <category android:name="android.intent.category.BROWSABLE" />
       <data android:scheme="https" android:host="app.yourdomain.com" />
   </intent-filter>
   ```

### 3. Configure Universal Links on iOS

1. Add `apple-app-site-association` on Firebase Hosting:

   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "TEAM_ID.com.example.app",
           "paths": ["/*"]
         }
       ]
     }
   }
   ```

2. Enable Associated Domains in **Xcode**:
    - Open **Xcode** → **Signing & Capabilities**.
    - Add `applinks:app.yourdomain.com` in **Associated Domains**.

### 4. Handle Deep Links in Flutter
Use `go_router` or `uni_links` package for handling deep links:

#### Using `go_router`:

```dart
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => DetailsPage(),
    ),
  ],
  initialLocation: '/',
);
```

#### Using `uni_links`:

```dart
void initDeepLinks() {
  uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      // Navigate to the corresponding page
      print("Navigated to: ${uri.path}");
    }
  });
}
```

## Testing
- Use `adb` to test deep links on Android:
  ```sh
  adb shell am start -a android.intent.action.VIEW -d "https://app.yourdomain.com/details" com.example.app
  ```
- Use Safari on iOS to test Universal Links.

## Conclusion
This guide helps set up Firebase App Links using a custom domain in Flutter post Firebase Dynamic Links deprecation. This ensures seamless deep linking across Android and iOS.

