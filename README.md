# product_listing_app

# Flutter Product Listing App

A complete Flutter-based product listing and e-commerce app built with Firebase Firestore, Riverpod, and Flutter flavors (dev & prod) to support multiple environments.

---

## Clone and Install

```bash
git clone https://github.com/Bharati1107/product_listing_app.git
cd product_listing_app
flutter pub get (for packages)
```

---

## Features

- Product list with image, name, brand, category, MRP, selling rate
- Real-time search
- Filters (by category, brand)
- Sort by name or MRP
- Product details view
- Add product (only when logged in)
- Add to cart with quantity control
- Cart page with full operations
- Light and Dark theme toggle
- Firebase Firestore backend
- Android, Web, iOS supported (iOS configured)
- Dev and Prod flavor support

---

## Test Login Credentials

Use the following dummy number for testing login (OTP is mocked):

- Phone Number: `+911234567890`
- OTP: `123456`

---

## Firebase Setup

### Firestore Collection: `products`

Each document must contain the following structure:

```json
{
  "id": 1,
  "name": "Product Name",
  "category": "Category",
  "brand": "Brand",
  "mrp": 1000,
  "sellingRate": 850,
  "imageUrl": "https://example.com/image.jpg",
  "description": "Product description here"
}
```

---

## Folder Structure

```
lib/
├── flavours/
│   ├── dev_env.dart
│   └── prod_env.dart
├── firebase_options_dev.dart
├── firebase_options_prod.dart
├── theme/
│   └── themes.dart
│   └── theme_provider.dart
├── model/
│   ├── product_model.dart
│   └── cart_model.dart
├── presentation/
│   ├── product/
│   │   ├── product_page.dart
│   │   ├── product_card.dart
│   │   ├── product_detail_page.dart
│   │   ├── add_edit_product_page.dart
│   │   ├── product_provider.dart
│   │   └── product_repository.dart
│   ├── cart/
│   │   ├── cart_page.dart
│   │   └── cart_provider.dart
│   └── user/
│       ├── auth_provider.dart
│       └── phone_auth_page.dart
```

---

## How to Run

### Android / iOS

**Dev Flavor:**

```bash
flutter run --flavor dev -t lib/flavours/dev_env.dart
```

**Prod Flavor:**

```bash
flutter run --flavor prod -t lib/flavours/prod_env.dart
```

### Web (Chrome)

**Dev:**

```bash
flutter run --flavor dev -t lib/flavours/dev_env.dart -d chrome
```

**Prod:**

```bash
flutter run --flavor prod -t lib/flavours/prod_env.dart -d chrome
```

---

## iOS Firebase Flavor Configuration

The iOS configuration is already set up in code.

### 1. Add Firebase Plist Files

Add the following files to:

- ios/Runner/GoogleService-Info-dev.plist  
- ios/Runner/GoogleService-Info-prod.plist

### 2. Create Build Configurations in Xcode

These steps must be performed manually on a Mac/Xcode system:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Go to Runner → Info → Configurations
3. Duplicate the existing Debug and Release configs:
   - Debug (dev)
   - Release (dev)
   - Debug (prod)
   - Release (prod)

### 3. Create and Edit Schemes

1. Go to Product > Scheme > Manage Schemes
2. Duplicate the existing Runner scheme:
   - Runner (dev)
   - Runner (prod)
3. For each scheme:
   - Click Edit Scheme
   - Set the Build Configuration:
     - Dev: Debug (dev), Release (dev)
     - Prod: Debug (prod), Release (prod)

### 4. Configure AppDelegate.swift (Already Done)

```swift
import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    var filePath: String?

    #if DEV
      filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")
    #elseif PROD
      filePath = Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")
    #endif

    if let filePath = filePath, 
       let options = FirebaseOptions(contentsOfFile: filePath) {
      FirebaseApp.configure(options: options)
    } else {
      fatalError("Could not find correct GoogleService-Info.plist")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 5. Add Swift Compiler Flags

In Build Settings for each configuration:

- Search: `Other Swift Flags`
- Add:
  - For dev: `-DDEV`
  - For prod: `-DPROD`

---

## Theme Switching

You can toggle between Light and Dark themes using the switch in the app bar.

---

## Adding Products

Only available after logging in.

- Tap the `+` floating button
- Fill in product details
- Submit the form to add it to Firebase Firestore

---

## Running Tests

You can run all tests using the following command:

```bash
flutter test test/screen/products/product_list_test.dart
```

Make sure the test file path is correct and exists.

---

## Notes

- iOS code and flavor setup is done but testing requires macOS and Xcode.
- Web and Android flavors are tested and working.
