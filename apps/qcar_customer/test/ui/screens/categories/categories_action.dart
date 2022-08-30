import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/ui/screens/categories/categories_page.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createCategoriesInfra() async {
  final car = await buildCarInfo();
  final sell = await buildSellInfo();
  return createTestInfra(
    carDataSource: mockCarSource(initialCars: [car]),
    sellDataSource: mockSellSource(initialSellInfo: [sell]),
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
