import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/server_client.dart';
import 'package:qcar_customer/core/service/auth_service.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/services.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/app_theme.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/app_router.dart';
import 'package:qcar_customer/ui/screens/app/app_vm.dart';
import 'package:qcar_customer/ui/screens/app/loading_page.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';

class AppInfrastructure {
  AppInfrastructure._({
    required this.database,
    required this.loadClient,
    required this.settingsSource,
    required this.infoService,
    required this.carInfoDataSource,
    required this.sellInfoDataSource,
    required this.authService,
    required this.uploadService,
    required this.settingsService,
  });

  factory AppInfrastructure.load({
    AppDatabase? database,
    DownloadClient? downloadClient,
    UploadClient? uploadClient,
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
    final downClient = downloadClient ?? ServerClient();
    //TODO make this not doppelt
    final upClient = uploadClient ?? ServerClient();
    final authService =
        authenticationService ?? AuthenticationService(FirebaseAuth.instance);
    final settingsService = SettingsService(settingsSource);
    final upService = uploadService ?? UploadService(settingsService, upClient);
    return AppInfrastructure._(
      database: db,
      loadClient: downClient,
      settingsSource: settingsSource,
      settingsService: settingsService,
      carInfoDataSource: carSource,
      sellInfoDataSource: sellSource,
      infoService: InfoService(downClient, carSource, sellSource),
      authService: authService,
      uploadService: upService,
    );
  }

  final AppDatabase database;
  final DownloadClient loadClient;
  final SettingsDataSource settingsSource;
  final UploadService uploadService;
  final AuthenticationService authService;
  final InfoService infoService;
  final CarInfoDataSource carInfoDataSource;
  final SellInfoDataSource sellInfoDataSource;
  final SettingsService settingsService;
}

class App extends View<AppViewModel> {
  App({AppInfrastructure? infrastructure})
      : super.model(AppVM(infrastructure: infrastructure));

  @override
  State<App> createState() => _AppState(viewModel);
}

class _AppState extends ViewState<App, AppViewModel> {
  _AppState(AppViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: widget.viewModel.isInitialized,
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
          return Services(
            infra: widget.viewModel.infra,
            child: MaterialApp(
              title: env + EnvironmentConfig.APP_NAME,
              theme: appTheme,
              darkTheme: appTheme,
              initialRoute: viewModel.firstRoute,
              onGenerateInitialRoutes: AppRouter.generateInitRoute,
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
}
