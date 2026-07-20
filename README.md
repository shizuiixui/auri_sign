<div align="center">
  <img src="assets/images/logo1.png" alt="AuriSign Logo" width="150" height="150">
  <h1>AuriSign</h1>
  <p>
    <b>Bridging Communication Through AI Technology</b>
  </p>
  <p>
    An interactive ecosystem designed to make Filipino Sign Language (FSL) accessible 
    through gamified lessons, a video dictionary, and real-time AI gesture recognition.
  </p>

  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB" />
  <img src="https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" alt="TensorFlow" />
</div>

---

## 🚀 Overview

**AuriSign** is an AI-assisted sign language learning platform that empowers inclusive communication. By combining traditional FSL education with modern AI, the platform allows for independent practice, instant feedback, and measurable skill development across both mobile and web platforms.

## ✨ Key Features

* **🔐 Universal Authentication**
    * Secure Login & Sign Up with JWT implementation.
    * Email OTP verification for account security.
    * Session restoration via Shared Preferences for seamless mobile access.

* **🤖 AI Gesture Recognition**
    * Real-time webcam and mobile camera-based hand sign detection.
    * Powered by **TensorFlow.js** to validate hand movements and signs instantly.

* **📖 Structured Learning & Dictionary**
    * Category-based curriculum (Alphabets, Numbers, Common Words).
    * Digital dictionary with visual examples and high-quality video references.

* **📊 Progress Tracking**
    * Personalized user profiles with learning analytics.
    * Daily activity tracker to maintain learning streaks and consistency.

---

## 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Mobile Frontend** | Flutter (Dart), Provider, GetIt, HTTP |
| **Web Frontend** | React 18, Vite, Bootstrap |
| **AI / ML** | TensorFlow.js (Gesture Recognition Model) |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB |
| **Authentication** | JWT & Email OTP Verification |

---

## 📦 Installation & Setup

To run the full ecosystem, you must start the **Backend Server** first, followed by the **Mobile App**.

### 1. Backend Server Setup

```bash
# Clone the server repository
git clone [https://github.com/bennybun29/AuriSign-Web.git](https://github.com/bennybun29/AuriSign-Web.git)

# Navigate to the server directory
cd AuriSign-Web/server

# Install dependencies
npm install

# Start the server (Development mode)
npm run dev
```
### 2. Mobile App Setup (Flutter)
Step 1: Clone the repository

```bash
git clone [https://github.com/kyranjosafat/auri_sign.git](https://github.com/kyranjosafat/auri_sign.git)
```

Step 2: Install Dependencies
```bash
flutter pub get
```

Step 3: Configure API Endpoint (Crucial)

Open lib/core/di/injection_container.dart.

Find the UserRepository registration.

Update the baseUrl to match your computer's local IP address (ensure your phone/emulator is on the same Wi-Fi).

Dart
// Example:
sl.registerLazySingleton<UserRepository>(
  () => UserRepository(baseUrl: '[http://192.000.0.0:5000/api](http://192.168.1.5:5000/api)'), // <--- Update this IP
);

Step 4: Run the App
```bash
flutter run
```
```bash
lib/
├── core/               # Shared utilities, widgets, and dependency injection
├── features/
│   ├── auth/           # Login, Signup, Session logic & ViewModels
│   ├── dictionary/     # FSL Dictionary and Video player
│   ├── homepage/       # Dashboard and Daily Trackers
│   ├── profile/        # Edit Profile, Settings, Image Upload
│   └── lessons/        # Gamified learning modules
└── main.dart           # Entry point & App Configuration
