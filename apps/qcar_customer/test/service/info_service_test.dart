import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/service/info_service.dart';

import '../builder/app_builder.dart';
import '../builder/entity_builder.dart';
import '../mocks/test_mock.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hasCars - no cars in db', () async {
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource();
    final sellDS = mockSellSource();
    final service = InfoService(loadClient, carDS, sellDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isFalse);
  });

  test('hasCars - cars + sell info in db', () async {
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource(initialCars: [await buildCarInfo()]);
    final sellDS = mockSellSource(initialSellInfo: [await buildSellInfo()]);
    final service = InfoService(loadClient, carDS, sellDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isTrue);
  });

  test('getIntroVideo - get path from sell info', () async {
    await prepareTest(); //because we need domain initialized
    final sellInfo = await buildSellInfo();
    final car = await buildCarInfo();
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource(initialCars: [car]);
    final sellDS = mockSellSource(initialSellInfo: [sellInfo]);
    final service = InfoService(loadClient, carDS, sellDS);

    final introPath = await service.getIntroVideo();
    expect(introPath != "", isTrue);
    expect(introPath.endsWith(sellInfo.introFilePath), isTrue);
  });
}
