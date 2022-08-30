import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/video/video_list_item.dart';

import '../../../utils/test_l10n.dart';
import '../categories/categories_action.dart';
import 'search_action.dart';
import 'search_checker.dart';

void main() {
  final videoItem = find.byType(VideoInfoListItem);

  testWidgets('Search Video - search bullshit - find nothing',
      (WidgetTester tester) async {
    await pushToCategories(tester);
    final l10n = await getTestL10n();

    await tapOnSearch(tester);
    checkSearchPage(l10n);
    await performSearch(tester, "bullshit");
    checkEmptySearch(l10n);
  });

  testWidgets('Search Video - search video', (WidgetTester tester) async {
    final infra = await pushToCategories(tester);
    final l10n = await getTestL10n();

    await tapOnSearch(tester);
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
    final infra = await pushToCategories(tester);
    final l10n = await getTestL10n();

    await tapOnSearch(tester);
    checkSearchPage(l10n);
    final category =
        (await infra.carInfoDataSource.getAllCars()).first.categories.first;
    await performSearch(tester, category.name);
    checkEmptySearch(l10n, isEmpty: false);
    expect(videoItem, findsNWidgets(2));
  });

  testWidgets('Search Video - search tag videos', (WidgetTester tester) async {
    await pushToCategories(tester);
    final l10n = await getTestL10n();

    await tapOnSearch(tester);
    checkSearchPage(l10n);
    await performSearch(tester, "luft");
    checkEmptySearch(l10n, isEmpty: false);
    expect(videoItem, findsNWidgets(2));
  });
}
