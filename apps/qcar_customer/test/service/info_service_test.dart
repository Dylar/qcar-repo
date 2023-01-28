import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/service/info_service.dart';

import '../builder/app_builder.dart';
import '../builder/entity_builder.dart';
import '../mocks/test_mock.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hasCars - no cars in db', () async {
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource();
    final saleDS = mockSaleSource();
    final favDS = mockFavoriteSource();
    final service = InfoService(loadClient, carDS, saleDS, favDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isFalse);
  });

  test('hasCars - cars + sale info in db', () async {
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource(initialCars: [await buildCarInfo()]);
    final saleDS = mockSaleSource(initialSaleInfo: [await buildSaleInfo()]);
    final favDS = mockFavoriteSource();
    final service = InfoService(loadClient, carDS, saleDS, favDS);

    final hasCars = await service.hasCars();
    expect(hasCars, isTrue);
  });

  test('getIntroVideo - get path from sale info', () async {
    await prepareTest(); //because we need domain initialized
    final saleInfo = await buildSaleInfo();
    final car = await buildCarInfo();
    final loadClient = mockDownloadClient();
    final carDS = mockCarSource(initialCars: [car]);
    final saleDS = mockSaleSource(initialSaleInfo: [saleInfo]);
    final favDS = mockFavoriteSource();
    final service = InfoService(loadClient, carDS, saleDS, favDS);

    final introPath = await service.getIntroVideo();
    expect(introPath != "", isTrue);
    expect(introPath.endsWith(saleInfo.introFilePath), isTrue);
  });
}
