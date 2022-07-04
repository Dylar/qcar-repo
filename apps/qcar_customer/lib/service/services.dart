import 'package:flutter/material.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/network/firestore_client.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/service/info_service.dart';

class Services extends InheritedWidget {
  final LoadClient loadClient;
  final SettingsDataSource settings;

  final InfoService infoService;

  const Services({
    required this.loadClient,
    required this.settings,
    required this.infoService,
    required Widget child,
    Key? key,
  }) : super(child: child);

  factory Services.init({
    AppDatabase? db,
    LoadClient? loadClient,
    SettingsDataSource? settings,
    InfoService? infoService,
    Key? key,
    required Widget child,
  }) {
    final database = db ?? AppDatabase();
    final client = loadClient ?? FirestoreClient();
    return Services(
      loadClient: client,
      infoService: infoService ??
          InfoService(client, CarInfoDS(database), SellInfoDS(database)),
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
