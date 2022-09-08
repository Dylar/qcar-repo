import 'package:flutter/material.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/service/auth_service.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';

class Services extends InheritedWidget {
  final DownloadClient loadClient;
  final SettingsDataSource settingsSource;
  final SettingsService settingsService;

  final AuthenticationService authService;

  final UploadService uploadService;
  final InfoService infoService;

  const Services._({
    required this.loadClient,
    required this.settingsSource,
    required this.settingsService,
    required this.uploadService,
    required this.authService,
    required this.infoService,
    required Widget child,
    Key? key,
  }) : super(child: child);

  factory Services.init({
    required AppInfrastructure infra,
    Key? key,
    required Widget child,
  }) {
    return Services._(
      loadClient: infra.loadClient, //TODO services only
      uploadService: infra.uploadService,
      authService: infra.authService,
      infoService: infra.infoService,
      settingsSource: infra.settingsSource, //TODO services only
      settingsService: infra.settingsService,
      key: key,
      child: child,
    );
  }

  static Services? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>();
  }

  @override
  bool updateShouldNotify(Services oldWidget) {
    return true;
  }
}
