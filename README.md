# Time Gen Flutter App

A Flutter mobile application for employer time tracking and employee management.

## Features

- Employee dashboard with quick access menu
- Time tracking functionality
- Employee management
- Modern, responsive UI design
- Cross-platform support (iOS & Android)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS builds)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Copy assets from the original project:
   - Copy all images from `public/` to `assets/images/`
   - Copy all SVG icons to `assets/icons/`

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── menu_item.dart
│   └── nav_item.dart
├── screens/                  # App screens
│   └── employer_dash_screen.dart
└── widgets/                  # Reusable widgets
    ├── app_header.dart
    ├── bottom_navigation.dart
    ├── menu_item_card.dart
    └── status_bar.dart
```

## Assets Setup

Make sure to copy the following assets from your original project:

### Images (copy to `assets/images/`):
- battery.png
- user-10.png
- identity-1.png
- report--1--2.png
- airplane-1.png
- gps--2--1.png
- event-3.png
- employee--1--2.png
- image-72.png
- rectangle-5578.svg
- time.svg
- mobile-signal.svg
- wifi.svg

### Icons (copy to `assets/icons/`):
- vector.svg

## Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request