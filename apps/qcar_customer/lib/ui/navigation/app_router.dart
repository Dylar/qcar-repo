import 'package:flutter/material.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/core/models/model_data.dart';
import 'package:qcar_customer/core/service/services.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';
import 'package:qcar_customer/ui/screens/cars/cars_vm.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_customer/ui/screens/cars/categories_vm.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/home/home_vm.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_vm.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_vm.dart';
import 'package:qcar_customer/ui/screens/settings/debug_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';
import 'package:qcar_customer/ui/screens/video/favorites_page.dart';
import 'package:qcar_customer/ui/screens/video/favorites_vm.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_vm.dart';
import 'package:qcar_customer/ui/screens/video/video_page.dart';
import 'package:qcar_customer/ui/screens/video/video_vm.dart';

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

  static List<Route<dynamic>> generateInitRoute(String initialRoute) {
    late WidgetBuilder builder;
    switch (initialRoute) {
      case DebugPage.routeName:
        builder = _navigateToDebug;
        break;
      case IntroPage.routeName:
        builder = _navigateToIntro;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
        break;
    }
    return [_wrapRoute(RouteSettings(name: initialRoute), builder)];
  }

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
        builder = (context) => _navigateToVideoSettings(context, arguments);
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
      case FavoritesPage.routeName:
        builder = (context) => _navigateToFavorites(context, arguments);
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
  final services = Services.of(context)!;
  return SettingsPage(SettingsVM(
    services.settingsService,
    services.trackingService,
  ));
}

Widget _navigateToVideoSettings(
  BuildContext context,
  Map<String, dynamic> arguments,
) {
  return VideoSettingsPage(arguments[ARGS_VIEW_MODEL]);
}

Widget _navigateToIntro(BuildContext context) {
  final services = Services.of(context)!;
  return IntroPage(IntroVM(services.settingsService, services.infoService));
}

Widget _navigateToHome(BuildContext context) {
  final services = Services.of(context)!;
  return HomePage(HomeVM(
    services.settingsService,
    services.trackingService,
    services.infoService,
  ));
}

Widget _navigateToCars(BuildContext context) {
  final services = Services.of(context)!;
  return CarsPage(CarsVM(
    services.trackingService,
    services.infoService,
  ));
}

Widget _navigateToVideoOverview(
    BuildContext context, Map<String, dynamic> arguments) {
  final services = Services.of(context)!;
  return VideoOverviewPage(
    VideoOverVM(
      services.trackingService,
      arguments[VideoOverviewPage.ARG_CAR],
      arguments[VideoOverviewPage.ARG_CATEGORY],
    ),
  );
}

Widget _navigateToFavorites(
    BuildContext context, Map<String, dynamic> arguments) {
  final services = Services.of(context)!;
  return FavoritesPage(
    FavoritesVM(
      services.trackingService,
      services.infoService,
      arguments[VideoOverviewPage.ARG_CAR],
    ),
  );
}

Widget _navigateToQrScan(BuildContext context) {
  final services = Services.of(context)!;
  return QrScanPage(QrVM(
    services.trackingService,
    services.infoService,
  ));
}

Widget _navigateToDirs(BuildContext context, Map<String, dynamic> arguments) {
  final services = Services.of(context)!;
  return CategoriesPage(
    CategoriesVM(
      services.trackingService,
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
      services.settingsService,
      services.trackingService,
      services.infoService,
      arguments[VideoPage.ARG_VIDEO]!,
    ),
    aspectRatio: width / height / 3, //16 / 9
  );
}
