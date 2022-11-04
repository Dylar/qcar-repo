import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';
import 'package:qcar_shared/utils/logger.dart';

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
    Logger.logI('🏠 Created $_sanitisedRoutePageName');
  }

  @mustCallSuper
  @override
  void initState() {
    Logger.logI('🏠 initState $_sanitisedRoutePageName');
    super.initState();
    viewModel.startInit();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    Logger.logI('🏠 didChangeDependencies $_sanitisedRoutePageName');
    super.didChangeDependencies();

    // subscribe for the change of route
    if (ModalRoute.of(context) != null) {
      Navigate.routeObserver
          .subscribe(this, ModalRoute.of(context)! as PageRoute);
    }

    viewModel.notifyListeners = () => setState(() {});
    viewModel.openDialog = (fun) async => fun(context);
    viewModel.showSnackBar = (fun) async => fun(context);
    viewModel.navigateTo = (spec) => Navigate.to(context, spec);
  }

  @mustCallSuper
  @override
  void dispose() {
    Logger.logI('🏠 dispose $_sanitisedRoutePageName');
    Navigate.routeObserver.unsubscribe(this);
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
