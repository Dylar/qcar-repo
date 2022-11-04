import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/ui/screens/app/app.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_business/ui/screens/intro/intro_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/utils/time_utils.dart';

abstract class AppViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>>? get progressValue;

  AppInfrastructure get infra;

  String get firstRoute;
}

class AppVM extends AppViewModel {
  AppVM({this.infrastructure});

  ValueNotifier<Tuple<double, double>>? progressValue;

  AppInfrastructure? infrastructure;

  AppInfrastructure get infra => infrastructure!;

  late String firstRoute;

  @override
  Future init() async {
    await atLeast(() async {
      final infra = await _initInfrastructure();

      progressValue = infrastructure!.infoService.progressValue;
      final signedIn = await infra.authService.signInAnon();
      if (!signedIn) {
        firstRoute = IntroPage.routeName;
      } else {
        final hasCars = await infra.infoService.hasCars();
        if (hasCars) {
          await infra.infoService.refreshCarInfos();
          firstRoute = HomePage.routeName;
        } else {
          firstRoute = IntroPage.routeName;
        }
      }
      infra.trackingService
          .sendTracking(TrackType.INFO, "App started: $firstRoute");
    }());
  }

  Future<AppInfrastructure> _initInfrastructure() async {
    if (infrastructure == null) {
      await dotenv.load(fileName: ".env");
      infrastructure = AppInfrastructure.load();
    }

    await infrastructure!.database.init();
    return infrastructure!;
  }
}
