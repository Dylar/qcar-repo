import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_routing.dart';

class Navigate {
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  static void pop<T>(BuildContext context, [T? result]) {
    final popSpec = RoutingSpec(
      routeName: '',
      action: RouteAction.pop,
      args: {POP_RESULT: result},
    );
    to(context, popSpec);
  }

  static Future<T> to<T>(BuildContext context, RoutingSpec spec) async {
    // Services.of(context)!
    //     .trackingService
    //     .sendTracking(TrackType.NAVIGATION, "Navi to: ${spec.name}");

    final arguments = spec.routingArguments;
    switch (spec.action) {
      //TODO complete list
      case RouteAction.pushTo:
        return (await Navigator.of(context).pushNamed(
          spec.routeName,
          arguments: arguments,
        )) as T;
      case RouteAction.popAndPushTo:
        return await Navigator.of(context).popAndPushNamed(
          spec.routeName,
          arguments: arguments,
        ) as T;
      case RouteAction.replaceWith:
        return await Navigator.of(context).pushReplacementNamed(
          spec.routeName,
          arguments: arguments,
        ) as T;
      case RouteAction.replaceAllWith:
        return await Navigator.of(context).pushNamedAndRemoveUntil(
          spec.routeName,
          (route) => false,
          arguments: arguments,
        ) as T;
      case RouteAction.pop:
        return Navigator.of(context).pop(arguments[POP_RESULT]) as T;
      case RouteAction.popUntil:
        return Navigator.of(context)
            .popUntil((route) => route.settings.name == spec.routeName) as T;
      case RouteAction.popUntilRoot:
        return Navigator.of(context).popUntil((route) => route.isFirst) as T;
      default:
        throw UnsupportedError("Unknown app route action");
    }
  }
}
