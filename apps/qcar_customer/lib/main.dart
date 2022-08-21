import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //TODO change this?
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    await dotenv.load(fileName: ".env");
    final sharedPref = await SharedPreferences.getInstance();
    runApp(App.load(SettingsService(sharedPref)));
  });
}
