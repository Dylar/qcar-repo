import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/navigation/app_router.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/service/services.dart';

import '../builder/app_builder.dart';

Future loadApp(WidgetTester tester, {AppInfrastructure? infra}) async {
  await prepareTest();
  // Build our app and trigger some frames.
  final appWidget = await App(infrastructure: infra ?? createTestInfra());
  await tester.pumpWidget(appWidget);
  for (int i = 0; i < 10; i++) {
    //TODO we need that?
    await tester.pump(Duration(seconds: 1));
  }
}

Future pushPage(
  WidgetTester tester, {
  required AppRouteSpec routeSpec,
  required Widget Function(Widget pushButton) wrapWith,
}) async {
  await prepareTest();
//we need to push page because "pushAndRemoveUntil" needs it ....
  final pushButton = Builder(
      builder: (context) => TextButton(
          onPressed: () => Navigate.to(context, routeSpec),
          child: const Placeholder()));

  final Widget widget = wrapWith(pushButton);

  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(const Duration(milliseconds: 10));

  await tester.tap(find.byType(TextButton));
  await tester.pump(const Duration(milliseconds: 10));
}

Widget wrapWidget(Widget widget, {AppInfrastructure? testInfra}) {
  final infra = testInfra ?? createTestInfra();
  return Services.init(
    downloadClient: infra.loadClient,
    settings: infra.settings,
    uploadService: infra.uploadService,
    authService: infra.authService,
    settingsService: infra.settingsService,
    infoService: infra.infoService,
    child: MaterialApp(
        title: EnvironmentConfig.APP_NAME,
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
        home: widget),
  );
}
