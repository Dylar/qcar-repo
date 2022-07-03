import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/service/info_service.dart';

import '../builder/entity_builder.dart';
import '../mocks/test_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hasCars - no cars in db', () async {
    final loadClient = mockLoadClient();
    final carDS = mockCarSource();
    final sellDS = mockSellSource();
    final service = InfoService(loadClient, carDS, sellDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isFalse);
  });

  test('hasCars - cars in db', () async {
    final loadClient = mockLoadClient();
    final carDS = mockCarSource(initialCars: [await buildCarInfo()]);
    final sellDS = mockSellSource();
    final service = InfoService(loadClient, carDS, sellDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isTrue);
  });

  test('getIntroVideo - get path from sell info', () async {
    final sellInfo = await buildSellInfo();
    final car = await buildCarInfo();
    final loadClient = mockLoadClient();
    final carDS = mockCarSource(initialCars: [car]);
    final sellDS = mockSellSource(initialSellInfo: [sellInfo]);
    final service = InfoService(loadClient, carDS, sellDS);

    final introPath = await service.getIntroVideo();
    expect(introPath != "", isTrue);
    expect(introPath == sellInfo.introFilePath, isTrue);
  });
}
