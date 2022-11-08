import 'package:flutter/material.dart';

const String POP_RESULT = "result";
const String TRANSITION_TIME = "trans_time";
const String TRANSITION_TYPE = "trans_type";

enum RouteAction {
  pushTo,
  popAndPushTo,
  pop,
  popUntil,
  popUntilRoot,
  replaceWith,
  replaceAllWith,
}

class RoutingSpec {
  final String routeName;
  final RouteAction action;

  final Map<String, dynamic> args;

  final Duration transitionTime;
  final TransitionType transitionType;

  Map<String, dynamic> get routingArguments => {
        TRANSITION_TIME: transitionTime,
        TRANSITION_TYPE: transitionType,
      }..addAll(args);

  const RoutingSpec({
    required this.routeName,
    this.action = RouteAction.pushTo,
    this.args = const {},
    this.transitionTime = const Duration(milliseconds: 300),
    this.transitionType = TransitionType.fading,
  });

  const RoutingSpec.popUntilRoot()
      : this(
          routeName: "",
          action: RouteAction.popUntilRoot,
        );
}

enum TransitionType {
  none,
  leftRight,
  rightLeft,
  topBottom,
  bottomTop,
  zoomIn,
  zoomOut,
  fading,
}

class RouteWrapper<T> extends MaterialPageRoute<T> implements Route<T> {
  RouteWrapper({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  Map<String, dynamic> get _arguments =>
      settings.arguments as Map<String, dynamic>? ?? {};

  @override
  Duration get transitionDuration =>
      (_arguments[TRANSITION_TIME] ?? Duration.zero) as Duration;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final transition =
        (_arguments[TRANSITION_TYPE] ?? TransitionType.none) as TransitionType;
    switch (transition) {
      case TransitionType.none:
        return child;
      case TransitionType.leftRight:
        return _slideTransition(const Offset(-1, 0), animation, child);
      case TransitionType.rightLeft:
        return _slideTransition(const Offset(1, 0), animation, child);
      case TransitionType.topBottom:
        return _slideTransition(const Offset(0, -1), animation, child);
      case TransitionType.bottomTop:
        return _slideTransition(const Offset(0, 1), animation, child);
      case TransitionType.zoomIn:
      case TransitionType.zoomOut:
        return _zoomTransition(animation, child);
      case TransitionType.fading:
        return FadeTransition(opacity: animation, child: child);
    }
  }

  Widget _slideTransition(
    Offset begin,
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  Widget _zoomTransition(
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
