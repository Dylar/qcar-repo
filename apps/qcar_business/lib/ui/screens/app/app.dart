import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qcar_business/core/datasource/car_data_source.dart';
import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/datasource/sale_data_source.dart';
import 'package:qcar_business/core/datasource/settings_data_source.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_business/core/network/mock_client.dart';
import 'package:qcar_business/core/network/server_client.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/core/service/services.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/navigation/app_router.dart';
import 'package:qcar_business/ui/screens/app/app_vm.dart';
import 'package:qcar_business/ui/screens/app/loading_page.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/error_widget.dart';

class AppInfrastructure {
  AppInfrastructure._({
    required this.database,
    required this.loadClient,
    required this.settingsSource,
    required this.infoService,
    required this.carInfoDataSource,
    required this.saleInfoDataSource,
    required this.authService,
    required this.trackingService,
    required this.settingsService,
  });

  factory AppInfrastructure.load({
    AppDatabase? database,
    DownloadClient? downloadClient,
    UploadClient? uploadClient,
    SettingsDataSource? settingsDataSource,
    CarInfoDataSource? carInfoDataSource,
    SaleInfoDataSource? saleInfoDataSource,
    AuthenticationService? authenticationService,
    TrackingService? trackingService,
  }) {
    final db = database ?? AppDatabase();
    final carSource = carInfoDataSource ?? CarInfoDS(db);
    final saleSource = saleInfoDataSource ?? SaleInfoDS(db);
    final settingsSource = settingsDataSource ?? SettingsDS(db);
    final downClient =
        MockClient(); //downloadClient ?? ServerClient(); //TODO use real client
    //TODO make this not doppelt
    final upClient = uploadClient ?? ServerClient();
    final authService = authenticationService ?? AuthenticationService();
    final settingsService = SettingsService(settingsSource);
    final trackService =
        trackingService ?? TrackingService(settingsService, upClient);
    return AppInfrastructure._(
      database: db,
      loadClient: downClient,
      settingsSource: settingsSource,
      settingsService: settingsService,
      carInfoDataSource: carSource,
      saleInfoDataSource: saleSource,
      infoService: InfoService(downClient),
      authService: authService,
      trackingService: trackService,
    );
  }

  final AppDatabase database;
  final DownloadClient loadClient;
  final SettingsDataSource settingsSource;
  final TrackingService trackingService;
  final AuthenticationService authService;
  final InfoService infoService;
  final CarInfoDataSource carInfoDataSource;
  final SaleInfoDataSource saleInfoDataSource;
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
              navigatorObservers: [Navigate.routeObserver],
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
