import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final AppClient appClient;
  final SettingsDataSource settings;

  final CarInfoService carInfoService;

  const Services({
    required this.appClient,
    required this.settings,
    required this.carInfoService,
    required Widget child,
    Key? key,
  }) : super(child: child);

  factory Services.init({
    AppDatabase? db,
    AppClient? appClient,
    SettingsDataSource? settings,
    CarInfoService? carInfoService,
    Key? key,
    required Widget child,
  }) {
    final database = db ?? AppDatabase();
    final client = appClient ?? AppClient();
    return Services(
      appClient: client,
      carInfoService:
          carInfoService ?? CarInfoService(client, CarInfoDS(database)),
      settings: settings ?? SettingsDS(database),
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
