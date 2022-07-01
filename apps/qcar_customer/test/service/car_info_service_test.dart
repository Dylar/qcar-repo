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

  test('getIntroVideo - select first video', () async {
    //TODO get from seller
    final car = await buildCarInfo();
    final loadClient = mockLoadClient();
    final carDS = mockCarSource(initialCars: [car]);
    final sellDS = mockSellSource();
    final service = InfoService(loadClient, carDS, sellDS);

    final introVid = await service.getIntroVideo();

    final lastVid = car.categories.last.videos.first;
    expect(lastVid.name == introVid.name, isFalse);
    final firstVid = car.categories.first.videos.first;
    expect(firstVid.name == introVid.name, isTrue);
  });
}
