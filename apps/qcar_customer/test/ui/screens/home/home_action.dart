import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createHomeInfra() async {
  final car = await buildCarInfo();
  final sale = await buildSaleInfo();
  return createTestInfra(
    carDataSource: mockCarSource(initialCars: [car]),
    saleDataSource: mockSaleSource(initialSaleInfo: [sale]),
  );
}

Future<AppInfrastructure> pushToHome(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final testInfra = infra ?? await createHomeInfra();
  await pushPage(
    tester,
    routeSpec: HomePage.pushIt(),
    wrapWith: (page) => wrapWidget(page, testInfra: testInfra),
  );
  return testInfra;
}
