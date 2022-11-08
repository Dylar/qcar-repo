import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_navigate.dart';

abstract class ViewModel {
  ViewModel();

  late void Function() notifyListeners;
  late void Function(AppRouteSpec) navigateTo;
  late Future Function(Function(BuildContext)) openDialog;
  late Future Function(Function(BuildContext)) showSnackBar;

  final _initializer = Completer();

  Future get isInitialized => _initializer.future;

  /// This method is executed whenever the Widget's Stateful State gets
  /// disposed. It might happen a few times, always matching the amount of times
  /// `init` is called.
  @mustCallSuper
  void dispose() {}

  /// This method is executed exactly once for each State object Flutter's
  /// framework creates.
  @mustCallSuper
  void startInit() {
    init().then((value) => finishInit());
  }

  Future init() async {}

  void finishInit() {
    if (!_initializer.isCompleted) {
      _initializer.complete();
      notifyListeners();
    }
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void routingDidPopNext() {}

  /// Called when the current route has been pushed.
  void routingDidPush() {}

  /// Called when the current route has been popped off.
  void routingDidPop() {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void routingDidPushNext() {}
}
