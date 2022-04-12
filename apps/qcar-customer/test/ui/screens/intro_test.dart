import 'dart:io';

import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../../builder/app_builder.dart';
import '../../builder/entity_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_interactions.dart';
import '../../utils/test_l10n.dart';
import '../../utils/test_navigation.dart';

@GenerateMocks([
  AppClient,
  AppDatabase,
  SettingsDataSource,
  CarInfoDataSource,
  VideoInfoDataSource,
  HttpClient,
  HttpHeaders,
  HttpClientRequest,
  HttpClientResponse,
])
void main() {
  testWidgets('Load app - got no cars - show intro screen',
      (WidgetTester tester) async {
    prepareTest();
    final l10n = await getTestL10n();
    await initNavigateToIntro(tester);
    expect(find.text(l10n.introPageMessage), findsOneWidget);
  });

  testWidgets('Load app - scan bullshit - show error',
      (WidgetTester tester) async {
    prepareTest();
    await initNavigateToIntro(tester);

    final l10n = await getTestL10n();
    expect(find.text(l10n.introPageMessageError), findsNothing);
    await scanOnIntroPage(tester, "Bullshit");
    expect(find.text(l10n.introPageMessageError), findsOneWidget);
  });

  testWidgets('Load app - scan wrong json - show error',
      (WidgetTester tester) async {
    prepareTest();
    await initNavigateToIntro(tester);

    final l10n = await getTestL10n();
    expect(find.text(l10n.introPageMessageError), findsNothing);
    await scanOnIntroPage(tester, "{}");
    expect(find.text(l10n.introPageMessageError), findsOneWidget);
  });

  testWidgets('Load app - show intro page - scan key - show home page',
      (WidgetTester tester) async {
    prepareTest();
    final l10n = await getTestL10n();

    final infra = defaultTestInfra();
    await initNavigateToIntro(tester, infra: infra);

    final key = await buildSellInfo();
    expect(find.text(l10n.introPageMessage), findsOneWidget);
    expect(find.text(l10n.introPageMessageScanning), findsNothing);
    await scanOnIntroPage(tester, key.toJson(), settle: false);
    expect(find.text(l10n.introPageMessage), findsNothing);
    expect(find.text(l10n.introPageMessageScanning), findsOneWidget);
    await tester.pump(Duration(milliseconds: 10));
    await tester.pump(Duration(milliseconds: 10));
    await tester.pump(Duration(milliseconds: 10));
    checkHomePage();
  });
}
