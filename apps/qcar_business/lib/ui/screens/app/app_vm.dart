import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/ui/screens/app/app.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';
import 'package:qcar_shared/utils/time_utils.dart';

abstract class AppViewModel extends ViewModel {
  AppInfrastructure get infra;

  String get firstRoute;
}

class AppVM extends AppViewModel {
  AppVM({this.infrastructure});

  AppInfrastructure? infrastructure;

  AppInfrastructure get infra => infrastructure!;

  late String firstRoute;

  @override
  Future init() async {
    await atLeast(() async {
      final infra = await _initInfrastructure();

      final signedIn = await infra.authService.isSignedIn();
      firstRoute = signedIn ? HomePage.routeName : LoginPage.routeName;
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
