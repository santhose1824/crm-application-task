# CRM Mobile Application
A modern and efficient mobile CRM (Customer Relationship Management) application built with Flutter, Firebase, and BLoC architecture. This app is designed to help businesses manage their agents, customers, communication, and collaboration—all from a mobile device.

---

## 🚀 Getting Started

### 📋 Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- Firebase Account
- Zego Account (for video calling)

### 🔧 Flutter Setup
1. **Install Flutter**
   ```bash
   # Download Flutter SDK from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. **Verify Installation**
   ```bash
   flutter doctor
   ```

3. **Clone and Setup Project**
   ```bash
   git clone <your-repository-url>
   cd crm-mobile-app
   flutter pub get
   ```

### 🔥 Firebase Setup

#### 1. Create Firebase Project
- Go to [Firebase Console](https://console.firebase.google.com/)
- Click "Create a project" or "Add project"
- Enter your project name and follow the setup wizard
- Enable Google Analytics (optional)

#### 2. Configure Firebase for Flutter

**For Android:**
1. In Firebase Console, click "Add app" → Android
2. Enter your package name (found in `android/app/build.gradle`)
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Add Firebase SDK to `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
6. Add plugin to `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

**For iOS:**
1. In Firebase Console, click "Add app" → iOS
2. Enter your bundle ID (found in `ios/Runner.xcodeproj`)
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` in Xcode

#### 3. Enable Firebase Services
1. **Authentication**
   - Go to Authentication → Sign-in method
   - Enable "Email/Password"
   
2. **Firestore Database**
   - Go to Firestore Database → Create database
   - Start in test mode (configure rules later)
   - Choose your region

3. **Storage** (if needed)
   - Go to Storage → Get started
   - Set up security rules

#### 4. Firebase Configuration
Create a `firebase_options.dart` file using FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 📞 Zego Setup (Video Calling)

1. **Create Zego Account**
   - Visit [Zego Console](https://console.zego.im/)
   - Sign up and create a new project
   - Get your `AppID` and `AppSign`

2. **Configure Zego**
   - Add your Zego credentials to your app configuration
   - Update the calling functionality to use Zego SDK

3. **Add Zego Dependencies**
   ```yaml
   dependencies:
     zego_uikit_prebuilt_call: ^latest_version
   ```

### 🏃‍♂️ Running the Application
```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

### 🔑 Demo Login Credentials

**Admin Login:**
- Email: `purposefirebase@gmail.com`
- Password: `Password123`

**Agent Login:**
- Email: `santhosemaha18@gmail.com`
- Password: `Password123`

> **Note:** These are demo accounts for testing purposes. Other data displayed in the app may be dummy data, but the core functionality fetches real data from Firebase.

---

## 📱 Features

### 🔐 Authentication
- Firebase Email & Password Login
- Role-based login for Admins and Agents
- AuthBloc integration for secure state management
- Session persistence using SharedPreferences

---

### 👤 Admin Module

#### Dashboard
- Welcome message
- Quick stats: Total Agents, Customers, Chats, Searches
- Analytical graphs: Bar and Pie charts

#### Agent Management
- Add, edit, delete agents (with Firebase Authentication)
- Display agent list with chat and call icons
- Assign customers to agents

#### Customer Management
- Add, edit, delete customers (stored in Firestore)
- Assign each customer to a specific agent
- View assigned agent in customer details
- Customer list with call and chat buttons

#### Chat Feature
- One-to-one chat between Admin and Agents or Customers
- Chat list separated by Agents and Customers
- Firestore-backed real-time messaging
- Timestamp and sender-aware chat bubbles

#### Search
- Search across Agents and Customers
- Filter chips to toggle between roles
- Live search by name, email, or phone
- Unified UI with role-based strip colors

#### Call Feature (In-App)
- Integrated with Zego SDK
- Admin can call Agents and Customers
- Call screen UI with mute, speaker, and end call

#### Settings
- Display current user info
- Change password (future scope)
- Help and support (placeholder)
- Logout (with AuthBloc and route clearing)

---

### 🧑 Agent Module

#### Dashboard
- Welcome banner
- Stats and placeholder widgets for future insights

#### Customers
- View only assigned customers
- List UI with chat and call buttons
- Tabs for Customer List and Call Logs

#### Chat
- Chat with Admin and Assigned Customers
- Unified UI as used in the Admin section
- Firestore-backed real-time chat

#### Settings
- View profile details
- Logout via AuthBloc
- UI consistent with Admin module

---

## 🛠️ Technologies Used
- **Flutter**: Cross-platform UI toolkit
- **Firebase**: Auth, Firestore, Storage
- **BLoC (flutter_bloc)**: For state management
- **SharedPreferences**: For local session persistence
- **Persistent Bottom Navigation Bar**: For modular navigation
- **Google Fonts**: Clean typography
- **Iconify Flutter**: Scalable and clean icon sets
- **Zego SDK**: For real-time voice and video calling

---


## 🔒 Security Rules

### Firestore Rules Example
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Chat messages
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 📌 Final Notes
- The app is modular and scalable.
- Authentication, role management, CRUD, chat, and calling are tightly integrated.
- While optional features like advanced analytics or notifications are not implemented due to time constraints, the core functionalities are production-ready.
- Make sure to configure proper Firebase security rules for production.
- Test the Zego calling functionality thoroughly before deployment.

---

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👏 Acknowledgments
Thanks to Flutter, Firebase, and Zego for the robust platforms that made this possible. And a huge shoutout to the developer—you—for building a well-structured and feature-rich CRM app! 🚀
