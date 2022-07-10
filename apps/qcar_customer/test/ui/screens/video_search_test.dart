import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/video/video_list_item.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_interactions.dart';
import '../../utils/test_l10n.dart';
import '../../utils/test_navigation.dart';

void main() {
  var videoItem = find.byType(VideoInfoListItem);

  testWidgets('Search Video - search bullshit - find nothing',
      (WidgetTester tester) async {
    prepareTest();
    final infra = defaultTestInfra();
    await initNavigateToCategories(tester, infra: infra);
    await tapOnSearch(tester);
    final l10n = await getTestL10n();
    checkSearchPage(l10n);
    await performSearch(tester, "bullshit");
    checkEmptySearch(l10n);
  });

  testWidgets('Search Video - search video', (WidgetTester tester) async {
    prepareTest();
    final infra = defaultTestInfra();
    await initNavigateToCategories(tester, infra: infra);
    await tapOnSearch(tester);
    final l10n = await getTestL10n();
    checkSearchPage(l10n);
    final vid = (await infra.carInfoDataSource.getAllCars())
        .first
        .categories
        .first
        .videos
        .first;
    await performSearch(tester, vid.name);
    checkEmptySearch(l10n, isEmpty: false);
    expect(videoItem, findsNWidgets(1));
    expect(
        find.descendant(
          of: videoItem,
          matching: find.text(vid.name, findRichText: true),
        ),
        findsNWidgets(1));
  });

  testWidgets('Search Video - search category videos',
      (WidgetTester tester) async {
    prepareTest();
    final infra = defaultTestInfra();
    await initNavigateToCategories(tester, infra: infra);
    await tapOnSearch(tester);
    final l10n = await getTestL10n();
    checkSearchPage(l10n);
    final category =
        (await infra.carInfoDataSource.getAllCars()).first.categories.first;
    await performSearch(tester, category.name);
    checkEmptySearch(l10n, isEmpty: false);
    expect(videoItem, findsNWidgets(2));
  });

  testWidgets('Search Video - search tag videos', (WidgetTester tester) async {
    prepareTest();
    final infra = defaultTestInfra();
    await initNavigateToCategories(tester, infra: infra);
    await tapOnSearch(tester);
    final l10n = await getTestL10n();
    checkSearchPage(l10n);
    await performSearch(tester, "luft");
    checkEmptySearch(l10n, isEmpty: false);
    expect(videoItem, findsNWidgets(2));
  });
}
