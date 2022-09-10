import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';

import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../app/app_checker.dart';
import '../app/feedback_action.dart';
import 'categories_action.dart';

void main() {
  testWidgets('CategoriesPage - render', (WidgetTester tester) async {
    await pushToCategories(tester);
    expect(find.byType(CategoriesPage), findsOneWidget);
    checkSearchIcon(isVisible: true);
    checkReloadIcon(isVisible: true);
    checkNavigationBar(CategoriesPage.routeName);
  });

  group('CategoriesPage - feedback test', () {
    testWidgets('CategoriesPage - cancel feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      await doCancelFeedback(tester, infra.uploadService);
    });

    testWidgets('CategoriesPage - success feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      mockFeedbackResponse(infra.uploadService, okResponse());
      await doSuccessFeedback(tester, infra.uploadService);
    });

    testWidgets('CategoriesPage - failed feedback',
        (WidgetTester tester) async {
      final infra = await pushToCategories(tester);
      await doFailedFeedback(tester, infra.uploadService);
    });
  });
}
