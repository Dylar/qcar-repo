import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/ui/navigation/app_router.dart';

import 'navigation/navi.dart';

abstract class View<VM extends ViewModel> extends StatefulWidget {
  final VM viewModel;

  const View.model(this.viewModel, {Key? key}) : super(key: key);
}

abstract class ViewState<V extends View, VM extends ViewModel> extends State<V>
    with RouteAware {
  late final VM _viewModel;

  VM get viewModel => _viewModel;

  String get _sanitisedRoutePageName {
    return '$runtimeType'.replaceAll('_', '').replaceAll('State', '');
  }

  @mustCallSuper
  ViewState(this._viewModel) {
    Logger.logI('Created $_sanitisedRoutePageName');
  }

  @mustCallSuper
  @override
  void initState() {
    Logger.logI('initState $_sanitisedRoutePageName');
    super.initState();
    viewModel.startInit();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // subscribe for the change of route
    if (ModalRoute.of(context) != null) {
      AppRouter.routeObserver
          .subscribe(this, ModalRoute.of(context)! as PageRoute);
    }

    viewModel.notifyListeners = () => this.setState(() {});
    viewModel.openDialog = (fun) async => fun(context);
    viewModel.showSnackBar = (fun) async => fun(context);
    viewModel.navigateTo = (spec) => Navigate.to(context, spec);
  }

  @mustCallSuper
  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    Logger.logI('dispose $_sanitisedRoutePageName');
    viewModel.dispose();
    super.dispose();
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @mustCallSuper
  @override
  void didPopNext() {
    Logger.logI('🚚 $_sanitisedRoutePageName didPopNext');
    viewModel.routingDidPopNext();
  }

  /// Called when the current route has been pushed.
  @mustCallSuper
  @override
  void didPush() {
    Logger.logI('🚚 $_sanitisedRoutePageName didPush');
    viewModel.routingDidPush();
  }

  /// Called when the current route has been popped off.
  @mustCallSuper
  @override
  void didPop() {
    Logger.logI('🚚 $_sanitisedRoutePageName didPop');
    viewModel.routingDidPop();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @mustCallSuper
  @override
  void didPushNext() {
    Logger.logI('🚚 $_sanitisedRoutePageName didPushNext');
    viewModel.routingDidPushNext();
  }
}

abstract class ViewModel {
  ViewModel();

  late void Function() notifyListeners;
  late void Function(AppRouteSpec) navigateTo;
  late Future Function(Function(BuildContext)) openDialog;
  late Future Function(Function(BuildContext)) showSnackBar;

  final _initializer = new Completer();

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
