# 💬 ChatVerse

> Your world of conversations.

ChatVerse is a real-time chat app built with **Flutter** and **Firebase**. Users can sign up, find other people by username, and chat instantly in a clean blue-themed interface with a WhatsApp-style doodle background.

---

## ✨ Features

- **Authentication**: email and password sign up / login with Firebase Auth
- **Form validation**: email, name, password (strength rules) and confirm password checks
- **User search**: live prefix search by username, your own account is excluded from results
- **Real-time messaging**: messages sync instantly using Cloud Firestore streams
- **Chat list**: all your conversations with last message, sender and time, newest first
- **Swipe to open**: swipe a chat tile and the chat screen slides in with your finger
- **Profile screen**: tap your avatar in the header to see your details and log out
- **Default avatars**: initial-letter avatar when a user has no profile picture
- **Custom UI**: navy and sky-blue theme, rounded chat area and a doodle-pattern chat background
- **Local session data**: user details cached with `shared_preferences`

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Local storage | shared_preferences |
| Date formatting | intl |

---

## 📂 Project Structure

```
ChatVerse/
├── app/                              # Flutter project
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── register.screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── chat_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── services/
│   │   │   ├── database.dart             # Firestore helper methods
│   │   │   └── shared_prefrence.dart     # local storage helper
│   │   ├── widgets/
│   │   │   ├── chat_widget.dart          # chat list
│   │   │   ├── search_widget.dart        # user search results
│   │   │   └── chat_background.dart      # doodle background
│   │   └── utils/
│   │       └── validators.dart           # email, name, password validators
│   ├── android/
│   └── pubspec.yaml
├── screenshots/
└── README.md
```

---

## 🗄 Firestore Structure

```
users/{uid}
  ├── uid
  ├── name
  ├── email
  ├── username
  └── dp

chatrooms/{chatRoomId}              # chatRoomId = both usernames, sorted, joined by "_"
  ├── users: [usernameA, usernameB]
  ├── lastMessage
  ├── lastMessageSendBy
  ├── lastMessageTime
  └── chats/{messageId}
        ├── message
        ├── sendBy
        └── time
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed (`flutter doctor` should pass)
- A Firebase project
- Android device or emulator

### Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/nikhilbishnoi007/ChatVerse.git
   cd ChatVerse/app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Connect Firebase** (run inside the `app` folder)

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This generates `lib/firebase_options.dart`. For Android, make sure `google-services.json` is inside `app/android/app/`.

4. **Enable services in the Firebase Console**

   - Authentication → Sign-in method → **Email/Password**
   - Firestore Database → **Create database**

5. **Set Firestore rules**

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {

       match /users/{userId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }

       match /chatrooms/{roomId} {
         allow read, write: if request.auth != null;

         match /chats/{messageId} {
           allow read, write: if request.auth != null;
         }
       }
     }
   }
   ```

   > These rules are meant for development. Tighten them before publishing.

6. **Run the app**

   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk --release
```

The APK will be at `app/build/app/outputs/flutter-apk/app-release.apk`.

---

## 🧪 Testing

Run the validator tests (inside the `app` folder):

```bash
flutter test
```

To test chatting you need two accounts. Use two devices, a phone and Chrome, or log in with the second account on the same device after logging out.

---

## ⚠️ Known Limitations

- Usernames are generated from the email prefix and are not guaranteed to be unique yet
- Chat room ids are built from usernames, so duplicate usernames can mix up chats
- Firestore rules are permissive and meant for development
- No profile photo upload, push notifications or media sharing yet

---

## 🗺 Roadmap

- [ ] Unique username check at registration
- [ ] Profile photo upload (Firebase Storage)
- [ ] Push notifications (FCM)
- [ ] Image sharing in chats
- [ ] Unread message count and read receipts
- [ ] Stricter Firestore security rules

---

## 👨‍💻 Author

**Nikhil Sinwar**

- GitHub: [@nikhilbishnoi007](https://github.com/nikhilbishnoi007)
- LinkedIn: [nikhilsinwar](https://linkedin.com/in/nikhilsinwar92568)