import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/categories/categories_page.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('CategoriesPage - all navigation visible',
      (WidgetTester tester) async {
    prepareTest();
    await initNavigateToCategories(tester);
    checkNavigationBar(CategoriesPage.routeName);
  });
}
