import 'package:flutter/material.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/core/service/services.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_business/ui/screens/home/home_vm.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';
import 'package:qcar_business/ui/screens/login/login_vm.dart';
import 'package:qcar_business/ui/screens/settings/debug_page.dart';
import 'package:qcar_business/ui/screens/settings/settings_page.dart';
import 'package:qcar_business/ui/screens/settings/settings_vm.dart';
import 'package:qcar_shared/utils/logger.dart';

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
  static List<Route<dynamic>> generateInitRoute(String initialRoute) {
    late WidgetBuilder builder;
    switch (initialRoute) {
      case DebugPage.routeName:
        builder = _navigateToDebug;
        break;
      case LoginPage.routeName:
        builder = _navigateToLogin;
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
      case LoginPage.routeName:
        builder = _navigateToLogin;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
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
  ));
}

Widget _navigateToLogin(BuildContext context) {
  final services = Services.of(context)!;
  return LoginPage(LoginVM(services.authService, services.infoService));
}

Widget _navigateToHome(BuildContext context) {
  final services = Services.of(context)!;
  return HomePage(HomeVM(services.settingsService));
}
