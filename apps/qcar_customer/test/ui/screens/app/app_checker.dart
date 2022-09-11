import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';

void checkNavigationBar(String thisPage) {
  final naviFinder = find.byType(AppNavigation);
  expect(naviFinder, findsOneWidget);
  final AppNavigation navi =
      naviFinder.first.evaluate().first.widget as AppNavigation;
  expect(navi.routeName, thisPage);
  naviBarData.forEach((data) {
    expect(
      find.descendant(
        of: naviFinder,
        matching: find.text(data.middleOrThrow),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: naviFinder,
        matching: find.byIcon(data.lastOrThrow),
      ),
      findsOneWidget,
    );
  });
}

void checkReloadIcon({bool isVisible = true}) {
  expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.refresh),
      ),
      isVisible ? findsOneWidget : findsNothing);
}

//TODO make this into checkAppBarIcons
void checkSearchIcon({bool isVisible = true}) {
  expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.search),
      ),
      isVisible ? findsOneWidget : findsNothing);
}
