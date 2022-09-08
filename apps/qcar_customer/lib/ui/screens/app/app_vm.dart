import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qcar_customer/core/helper/player_config.dart';
import 'package:qcar_customer/core/helper/time_utils.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:qcar_customer/ui/navigation/app_viewmodel.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppState { STARTING, SIGN_IN, SCAN_QR, GO_HOME }

abstract class AppViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>>? get progressValue;

  AppInfrastructure? get infrastructure;

  Future<String> initApp();
}

class AppVM extends AppViewModel {
  AppVM({this.infrastructure});

  AppInfrastructure? infrastructure;

  ValueNotifier<Tuple<double, double>>? progressValue;

  Future<String> initApp() async {
    final start = DateTime.now();
    final infra = await _initInfrastructure();

    final AppState state;
    final signedIn = await infra.authService.signInAnon();
    if (!signedIn) {
      state = AppState.SIGN_IN;
    } else {
      final hasCars = await infra.infoService.hasCars();
      if (hasCars) {
        await infra.infoService.refreshCarInfos();
        state = AppState.GO_HOME;
      } else {
        state = AppState.SCAN_QR;
      }
    }
    await waitDiff(start);
    return state == AppState.GO_HOME ? HomePage.routeName : IntroPage.routeName;
  }

  Future<AppInfrastructure> _initInfrastructure() async {
    if (infrastructure == null) {
      await Firebase.initializeApp();
      //TODO enable persistence?
      FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
      await dotenv.load(fileName: ".env");
      final sharedPref = await SharedPreferences.getInstance();
      infrastructure = AppInfrastructure.load(SettingsService(sharedPref));
    }

    await infrastructure!.database.init();

    final settings = await infrastructure!.settings.getSettings();
    final vidSettings = initPlayerSettings();

    if (settings.videos.isEmpty || //TODO make anders -> ab in settings service
        settings.videos.length != vidSettings.length) {
      settings.videos = vidSettings;
      infrastructure!.settings.saveSettings(settings);
    }

    progressValue = infrastructure!.infoService.progressValue;

    return infrastructure!;
  }
}
