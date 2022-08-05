import 'package:flutter/material.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/service/services.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';
import 'package:qcar_customer/ui/screens/categories/categories_page.dart';
import 'package:qcar_customer/ui/screens/debug_page.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/intro/landing_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';
import 'package:qcar_customer/ui/screens/video/video_page.dart';
import 'package:qcar_customer/ui/viewmodels/car_overview_vm.dart';
import 'package:qcar_customer/ui/viewmodels/categories_vm.dart';
import 'package:qcar_customer/ui/viewmodels/home_vm.dart';
import 'package:qcar_customer/ui/viewmodels/intro_vm.dart';
import 'package:qcar_customer/ui/viewmodels/landing_vm.dart';
import 'package:qcar_customer/ui/viewmodels/qr_vm.dart';
import 'package:qcar_customer/ui/viewmodels/video_overview_vm.dart';
import 'package:qcar_customer/ui/viewmodels/video_vm.dart';

import '../tracking.dart';

abstract class AppRoute<T> extends Route<T> {
  String get appName;

  String? get viewName;
}

class RouteWrapper<T> extends MaterialPageRoute<T> implements AppRoute<T> {
  RouteWrapper({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  String get appName => EnvironmentConfig.APP_NAME;

  @override
  String? get viewName => settings.name;

  @override //TODO do into args/settings
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class AppRouter {
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  static AppRoute<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};
    Logger.logI("Route: ${settings.name}");

    late WidgetBuilder builder;
    switch (settings.name) {
      case DebugPage.routeName:
        builder = _navigateToDebug;
        break;
      case SettingsPage.routeName:
        builder = _navigateToSettings;
        break;
      case VideoSettingsPage.routeName:
        builder = _navigateToVideoSettings;
        break;
      case LandingPage.routeName:
        builder = _navigateToLanding;
        break;
      case IntroPage.routeName:
        builder = _navigateToIntro;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
        break;
      case QrScanPage.routeName:
        builder = _navigateToQrScan;
        break;
      case CarsPage.routeName:
        builder = _navigateToCars;
        break;
      case VideoOverviewPage.routeName:
        builder = (context) => _navigateToVideoOverview(context, arguments);
        break;
      case CategoriesPage.routeName:
        builder = (context) => _navigateToDirs(context, arguments);
        break;
      case VideoPage.routeName:
        builder = (context) => _navigateToVideo(context, arguments);
        break;
      default:
        throw Exception('Route ${settings.name} not implemented');
    }

    return _wrapRoute(settings, builder);
  }

  static RouteWrapper _wrapRoute(
    RouteSettings settings,
    WidgetBuilder buildWidget,
  ) =>
      RouteWrapper(settings: settings, builder: buildWidget);
}

//------------------Navigate to page------------------//

Widget _navigateToDebug(BuildContext context) {
  return DebugPage();
}

Widget _navigateToSettings(BuildContext context) {
  return SettingsPage();
}

Widget _navigateToVideoSettings(BuildContext context) {
  return VideoSettingsPage(Services.of(context)!.settings);
}

Widget _navigateToLanding(BuildContext context) {
  final services = Services.of(context)!;
  return LandingPage.model(
      LandingVM(services.authService, services.infoService));
}

Widget _navigateToIntro(BuildContext context) {
  final services = Services.of(context)!;
  return IntroPage.model(IntroVM(services.infoService));
}

Widget _navigateToHome(BuildContext context) {
  final services = Services.of(context)!;
  return HomePage(HomeVM(
    services.uploadService,
    services.infoService,
  ));
}

Widget _navigateToCars(BuildContext context) {
  final services = Services.of(context)!;
  return CarsPage.model(CarsVM(
    services.uploadService,
    services.infoService,
  ));
}

Widget _navigateToVideoOverview(
    BuildContext context, Map<String, dynamic> arguments) {
  final services = Services.of(context)!;
  return VideoOverviewPage.model(
    VideoOverVM(
      services.uploadService,
      arguments[VideoOverviewPage.ARG_CAR],
      arguments[VideoOverviewPage.ARG_CATEGORY],
    ),
  );
}

Widget _navigateToQrScan(BuildContext context) {
  final services = Services.of(context)!;
  return QrScanPage(QrVM(
    services.uploadService,
    services.infoService,
  ));
}

Widget _navigateToDirs(BuildContext context, Map<String, dynamic> arguments) {
  final services = Services.of(context)!;
  return CategoriesPage.model(
    CategoriesVM(
      services.uploadService,
      services.infoService,
      arguments[CategoriesPage.ARG_CAR],
    ),
  );
}

Widget _navigateToVideo(BuildContext context, Map<String, dynamic> arguments) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final services = Services.of(context)!;
  return VideoPage(
    VideoVM(
      services.uploadService,
      arguments[VideoPage.ARG_VIDEO],
    ),
    aspectRatio: width / height / 3, //16 / 9
  );
}
