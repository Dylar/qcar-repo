import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_customer/ui/screens/cars/favorites_button.dart';
import 'package:qcar_customer/ui/screens/video/favorites_page.dart';

import '../../../builder/entity_builder.dart';
import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_l10n.dart';
import '../app/app_checker.dart';
import '../app/dialog_checker.dart';
import '../app/feedback_action.dart';
import 'categories_action.dart';

void main() {
  testWidgets('CategoriesPage - render', (WidgetTester tester) async {
    await pushToCategories(tester);
    expect(find.byType(CategoriesPage), findsOneWidget);
    checkSearchIcon(isVisible: true);
    checkReloadIcon(isVisible: true);
    expect(find.byType(FavoritesButton), findsOneWidget);
    checkNavigationBar(CategoriesPage.routeName);
  });

  group('CategoriesPage - feedback test', () {
    testWidgets('CategoriesPage - cancel feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      await doCancelFeedback(tester, infra.trackingService);
    });

    testWidgets('CategoriesPage - success feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      mockFeedbackResponse(infra.trackingService, okResponse());
      await doSuccessFeedback(tester, infra.trackingService, -1);
      await doSuccessFeedback(tester, infra.trackingService, 0);
      await doSuccessFeedback(tester, infra.trackingService, 1);
    });

    testWidgets('CategoriesPage - failed feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      await doFailedFeedback(tester, infra.trackingService);
    });
  });

  testWidgets(
      'CategoriesPage - tap on favorite button - show NoFavoritesDialog',
      (WidgetTester tester) async {
    final l10n = await getTestL10n();
    await pushToCategories(tester);
    checkInfoDialog(l10n.noFavoritesTitle, l10n.noFavoritesMessage,
        isVisible: false);
    await tester.tap(find.byType(FavoritesButton));
    await tester.pump();
    checkInfoDialog(l10n.noFavoritesTitle, l10n.noFavoritesMessage);
  });

  testWidgets('CategoriesPage - tap on favorite button - show favorites page',
      (WidgetTester tester) async {
    final l10n = await getTestL10n();
    final vid = await buildVideoInfo();
    final infra =
        await createCategoriesInfra(initialFavorites: [vid.toFavorite]);
    await pushToCategories(tester, infra: infra);

    checkInfoDialog(l10n.noFavoritesTitle, l10n.noFavoritesMessage,
        isVisible: false);
    await tester.tap(find.byType(FavoritesButton));
    await tester.pump();
    checkInfoDialog(l10n.noFavoritesTitle, l10n.noFavoritesMessage,
        isVisible: false);

    expect(find.byType(FavoritesPage), findsOneWidget);
  });
}
