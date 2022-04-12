import 'package:carmanual/ui/screens/dir/dir_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('DirPage - all navigation visible', (WidgetTester tester) async {
    prepareTest();
    await initNavigateToDir(tester);
    checkNavigationBar(DirPage.routeName);
  });
}
