import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/helper/player_config.dart';
import 'package:qcar_customer/core/navigation/app_router.dart';
import 'package:qcar_customer/core/network/firestore_client.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/service/auth_service.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/services.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/screens/intro/loading_page.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';

class AppInfrastructure {
  AppInfrastructure({
    required this.database,
    required this.loadClient,
    required this.settings,
    required this.infoService,
    required this.carInfoDataSource,
    required this.sellInfoDataSource,
    required this.authService,
    required this.uploadService,
  });

  factory AppInfrastructure.load({
    DownloadClient? downloadClient,
    UploadClient? uploadClient,
    AppDatabase? database,
    SettingsDataSource? settingsDataSource,
    CarInfoDataSource? carInfoDataSource,
    SellInfoDataSource? sellInfoDataSource,
    AuthenticationService? authenticationService,
    UploadService? uploadService,
  }) {
    final db = database ?? AppDatabase();
    final carSource = carInfoDataSource ?? CarInfoDS(db);
    final sellSource = sellInfoDataSource ?? SellInfoDS(db);
    final settingsSource = settingsDataSource ?? SettingsDS(db);
    final downClient = downloadClient ?? FirestoreClient();
    final upClient = uploadClient ?? FirestoreClient();
    final authService =
        authenticationService ?? AuthenticationService(FirebaseAuth.instance);
    return AppInfrastructure(
      database: db,
      loadClient: downClient,
      settings: settingsSource,
      carInfoDataSource: carSource,
      sellInfoDataSource: sellSource,
      infoService: InfoService(downClient, carSource, sellSource),
      authService: authService,
      uploadService: uploadService ?? UploadService(upClient),
    );
  }

  final AppDatabase database;
  final DownloadClient loadClient;
  final SettingsDataSource settings;
  final UploadService uploadService;
  final AuthenticationService authService;
  final InfoService infoService;
  final CarInfoDataSource carInfoDataSource;
  final SellInfoDataSource sellInfoDataSource;
}

class App extends StatefulWidget {
  const App({required this.infrastructure}) : super();

  factory App.load() => App(infrastructure: AppInfrastructure.load());

  final AppInfrastructure infrastructure;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        initialData: false,
        future: _initApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return fixView(ErrorInfoWidget(snapshot.error!));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return fixView(LoadingStartPage());
          }

          final env = EnvironmentConfig.ENV == Env.PROD.name
              ? ""
              : "(${EnvironmentConfig.ENV}) ";

          final infra = widget.infrastructure;
          return Services(
            loadClient: infra.loadClient,
            settings: infra.settings,
            uploadService: infra.uploadService,
            authService: infra.authService,
            infoService: infra.infoService,
            child: MaterialApp(
              title: env + EnvironmentConfig.APP_NAME,
              theme: appTheme,
              darkTheme: appTheme,
              onGenerateRoute: AppRouter.generateRoute,
              navigatorObservers: [AppRouter.routeObserver],
              supportedLocales: const [Locale('en'), Locale('de')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        });
  }

  Directionality fixView(Widget widget) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: widget),
    );
  }

  Future _initApp() async {
    final infra = widget.infrastructure;
    await infra.database.init();

    final settings = await infra.settings.getSettings();
    final vidSettings = initPlayerSettings();

    if (settings.videos.isEmpty ||
        settings.videos.length != vidSettings.length) {
      settings.videos = vidSettings;
      infra.settings.saveSettings(settings);
    }
  }
}
