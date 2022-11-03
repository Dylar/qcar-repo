import 'package:flutter/material.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/screens/app/app.dart';

class Services extends InheritedWidget {
  final AppInfrastructure infra;

  SettingsService get settingsService => infra.settingsService;
  AuthenticationService get authService => infra.authService;
  TrackingService get trackingService => infra.trackingService;
  InfoService get infoService => infra.infoService;

  const Services({
    required this.infra,
    required Widget child,
  }) : super(child: child);

  static Services? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>();
  }

  @override
  bool updateShouldNotify(Services oldWidget) {
    return true;
  }
}
