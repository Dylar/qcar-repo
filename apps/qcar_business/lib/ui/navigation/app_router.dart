import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/service/services.dart';
import 'package:qcar_business/ui/screens/form/form_cars_page.dart';
import 'package:qcar_business/ui/screens/form/form_customer_page.dart';
import 'package:qcar_business/ui/screens/form/form_videos_page.dart';
import 'package:qcar_business/ui/screens/form/form_vm.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_business/ui/screens/home/home_vm.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';
import 'package:qcar_business/ui/screens/login/login_vm.dart';
import 'package:qcar_business/ui/screens/settings/debug_page.dart';
import 'package:qcar_business/ui/screens/settings/settings_page.dart';
import 'package:qcar_business/ui/screens/settings/settings_vm.dart';
import 'package:qcar_business/ui/screens/sold/sold_page.dart';
import 'package:qcar_business/ui/screens/sold/sold_vm.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/utils/logger.dart';

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

  static RouteWrapper generateRoute(RouteSettings settings) {
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
      case SoldPage.routeName:
        builder = (context) => _navigateToSold(context, arguments);
        break;
      case FormCarsPage.routeName:
        builder = _navigateToFormCars;
        break;
      case FormVideosPage.routeName:
        builder = (context) => _navigateToFormVideos(context, arguments);
        break;
      case FormCustomerPage.routeName:
        builder = (context) => _navigateToFormCustomer(context, arguments);
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
  return HomePage(HomeVM(services.authService, services.infoService));
}

Widget _navigateToSold(
  BuildContext context,
  Map<String, dynamic> arguments,
) {
  final services = Services.of(context)!;
  return SoldPage(SoldVM(
    services.infoService,
    arguments[ARGS_SELL_INFO],
  ));
}

Widget _navigateToFormCars(BuildContext context) {
  final services = Services.of(context)!;
  return FormCarsPage(FormVM(services.authService, services.infoService));
}

Widget _navigateToFormVideos(
  BuildContext context,
  Map<String, dynamic> arguments,
) =>
    FormVideosPage(arguments[ARGS_VIEW_MODEL]!);

Widget _navigateToFormCustomer(
  BuildContext context,
  Map<String, dynamic> arguments,
) =>
    FormCustomerPage(arguments[ARGS_VIEW_MODEL]!);
