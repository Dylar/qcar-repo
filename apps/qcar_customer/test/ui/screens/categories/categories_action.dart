import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/favorite.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createCategoriesInfra(
    {List<Favorite>? initialFavorites}) async {
  final car = await buildCarInfo();
  final sell = await buildSellInfo();
  return createTestInfra(
    carDataSource: mockCarSource(initialCars: [car]),
    sellDataSource: mockSellSource(initialSellInfo: [sell]),
    favoriteDataSource: mockFavoriteSource(initialFavorites: initialFavorites),
  );
}

Future<AppInfrastructure> pushToCategories(
  WidgetTester tester, {
  AppInfrastructure? infra,
  CarInfo? info,
}) async {
  final testInfra = infra ?? await createCategoriesInfra();
  final testInfo =
      info ?? (await testInfra.carInfoDataSource.getAllCars()).first;
  await pushPage(
    tester,
    routeSpec: CategoriesPage.pushIt(testInfo),
    wrapWith: (page) => wrapWidget(page, testInfra: testInfra),
  );
  return testInfra;
}
