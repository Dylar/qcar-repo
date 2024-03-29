import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/service/services.dart';
import 'package:qcar_customer/ui/navigation/app_router.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';

import '../builder/app_builder.dart';

Future loadApp(WidgetTester tester, {AppInfrastructure? infra}) async {
  await prepareTest();
  final appWidget = App(infrastructure: infra ?? createTestInfra());
  await tester.pumpWidget(appWidget);
  await tester.pump(Duration(seconds: 3));
  await tester.pump();
}

Future pushPage(
  WidgetTester tester, {
  required RoutingSpec routeSpec,
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
  await tester.pump(const Duration(milliseconds: 10));
}

Widget wrapWidget(Widget widget, {AppInfrastructure? testInfra}) {
  return Services(
    infra: testInfra ?? createTestInfra(),
    child: MaterialApp(
        title: EnvironmentConfig.APP_NAME,
        theme: appTheme,
        //TODO make real light theme
        darkTheme: appTheme,
        //TODO make real dark theme
        onGenerateRoute: AppRouter.generateRoute,
        navigatorObservers: [Navigate.routeObserver],
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
