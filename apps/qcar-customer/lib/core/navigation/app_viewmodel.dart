import 'dart:async';

import 'package:carmanual/core/navigation/app_router.dart';
import 'package:carmanual/core/tracking.dart';
import 'package:flutter/material.dart';

import 'navi.dart';

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
    Logger.logI('Created $runtimeType.');
  }

  @mustCallSuper
  @override
  void initState() {
    Logger.logI('initState $_sanitisedRoutePageName');
    super.initState();
    viewModel.init();
    listenToRoutesSpecs(viewModel._routeController.stream);
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

  /// Listens to the stream and automatically routes users according to the
  /// route spec.
  StreamSubscription<AppRouteSpec> listenToRoutesSpecs(
    Stream<AppRouteSpec> routes,
  ) =>
      routes.listen((spec) => Navigate.to(context, spec));
}

abstract class ViewModelProvider<T extends ViewModel> extends ChangeNotifier {
  ViewModelProvider(this.viewModel) {
    viewModel.notifyListeners = () => notifyListeners();
  }

  T viewModel;
}

abstract class ViewModel {
  ViewModel();

  late StreamController<AppRouteSpec> _routeController;
  late void Function() notifyListeners;

  /// This method is executed exactly once for each State object Flutter's
  /// framework creates.
  @mustCallSuper
  void init() {
    _routeController = StreamController();
  }

  ///  This method is executed whenever the Widget's Stateful State gets
  /// disposed. It might happen a few times, always matching the amount of times
  /// `init` is called.
  @mustCallSuper
  void dispose() {
    _routeController.close();
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

  void navigateTo(AppRouteSpec routeSpec) {
    _routeController.sink.add(routeSpec);
  }
}
