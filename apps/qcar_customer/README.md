# QCar

Create app icon: (https://pub.dev/packages/flutter_launcher_icons)
    flutter pub run flutter_launcher_icons:main

Linter:
 flutter analyze

Localization:
    if not resolved => Dart Analysis tab -> Restart Dart Analysis Server

Run:
 flutter run --dart-define=ENV="DEV" --dart-define=FLAVOR="TEST"
 flutter run --dart-define=ENV="DEV",FLAVOR="TEST"

 Env: DEV,STAGE,PROD
 Flavors: TEST

Build:
    flutter pub run build_runner build --delete-conflicting-outputs
    flutter packages get
    flutter packages pub run build_runner build --delete-conflicting-outputs (for testing)