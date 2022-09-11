import 'package:flutter/material.dart';
import 'package:qcar_customer/core/models/Tracking.dart';
import 'package:qcar_customer/core/service/services.dart';

const String POP_RESULT = "result";

enum AppRouteAction {
  pushTo,
  popAndPushTo,
  pop,
  popUntil,
  popUntilRoot,
  replaceWith,
  replaceAllWith,
}

class AppRouteSpec {
  /// The route that the `action` will use to perform the action (push,
  /// replace, pop, etc).
  final String name;

  /// Arguments for the route. Arguments for Pop actions are ignored.
  /// Default empty.
  final Map<String, dynamic> arguments;

  /// Defaults to `AppRouteAction.pushTo`
  final AppRouteAction action;

  const AppRouteSpec({
    required this.name,
    this.arguments = const {},
    this.action = AppRouteAction.pushTo,
  });

  const AppRouteSpec.popUntilRoot()
      : name = '',
        action = AppRouteAction.popUntilRoot,
        arguments = const {};
}

class Navigate {
  static void pop<T>(BuildContext context, [T? result]) {
    final popSpec = AppRouteSpec(
      name: '',
      action: AppRouteAction.pop,
      arguments: {POP_RESULT: result},
    );
    to(context, popSpec);
  }

  static Future<T> to<T>(BuildContext context, AppRouteSpec spec) async {
    Services.of(context)!
        .trackingService
        .sendTracking(TrackType.NAVIGATION, "Navi to: ${spec.name}");
    switch (spec.action) {
      //TODO complete list
      case AppRouteAction.pushTo:
        return (await Navigator.of(context).pushNamed(
          spec.name,
          arguments: spec.arguments,
        )) as T;
      case AppRouteAction.popAndPushTo:
        return await Navigator.of(context).popAndPushNamed(
          spec.name,
          arguments: spec.arguments,
        ) as T;
      case AppRouteAction.replaceWith:
        return await Navigator.of(context).pushReplacementNamed(
          spec.name,
          arguments: spec.arguments,
        ) as T;
      case AppRouteAction.replaceAllWith:
        return await Navigator.of(context).pushNamedAndRemoveUntil(
          spec.name,
          (route) => false,
          arguments: spec.arguments,
        ) as T;
      case AppRouteAction.pop:
        return Navigator.of(context).pop(spec.arguments[POP_RESULT]) as T;
      case AppRouteAction.popUntil:
        return Navigator.of(context)
            .popUntil((route) => route.settings.name == spec.name) as T;
      case AppRouteAction.popUntilRoot:
        return Navigator.of(context).popUntil((route) => route.isFirst) as T;
      default:
        throw UnsupportedError("Unknown app route action");
    }
  }
}
