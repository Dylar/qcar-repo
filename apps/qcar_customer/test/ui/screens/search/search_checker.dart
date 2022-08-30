import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_l10n.dart';

void checkSearchPage(TestAppLocalization l10n) {
  expect(find.text(l10n.searchStartText), findsOneWidget);
}

void checkEmptySearch(TestAppLocalization l10n, {bool isEmpty = true}) {
  expect(
    find.text(l10n.searchEmptyText),
    isEmpty ? findsOneWidget : findsNothing,
  );
}
