# QCar - under construction -

Create app icon: (https://pub.dev/packages/flutter_launcher_icons)
    flutter pub run flutter_launcher_icons:main

Linter:
 flutter analyze

Localization:
    flutter gen-l10n
    if not resolved => Dart Analysis tab -> Restart Dart Analysis Server

Clean:
    flutter pub cache clean
    pub global deactivate protoc_plugin ; pub global activate protoc_plugin

Build:
    flutter pub run build_runner build --delete-conflicting-outputs
    flutter packages get
    flutter packages pub run build_runner build --delete-conflicting-outputs (for testing)

Run:
    flutter run --dart-define=ENV="DEV" --dart-define=FLAVOR="TEST"
    flutter run --dart-define=ENV="DEV",FLAVOR="TEST"
    
    flutter run --dart-define=ENV="DEV" --flavor dev
    
    Env: DEV,STAGE,PROD
    Flavors: TEST
