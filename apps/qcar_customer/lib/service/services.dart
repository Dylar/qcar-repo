import 'package:flutter/material.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/network/firestore_client.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/service/car_info_service.dart';

class Services extends InheritedWidget {
  final LoadClient appClient;
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
    LoadClient? appClient,
    SettingsDataSource? settings,
    CarInfoService? carInfoService,
    Key? key,
    required Widget child,
  }) {
    final database = db ?? AppDatabase();
    final client = appClient ?? FirestoreClient();
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
