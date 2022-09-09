import 'package:flutter/material.dart';
import 'package:qcar_customer/core/service/auth_service.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';

class Services extends InheritedWidget {
  final AppInfrastructure infra;

  SettingsService get settingsService => infra.settingsService;
  AuthenticationService get authService => infra.authService;
  UploadService get uploadService => infra.uploadService;
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
