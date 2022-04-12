class VideoService {
  VideoService();

  // Future<Tuple<QrScanState, CarInfo>> onNewScan(String scan) async {
  //   print("Logging: scan: $scan");
  //   try {
  //     Map<String, dynamic> infoMap = jsonDecode(scan);
  //     final carInfo = CarInfo.fromMap(infoMap);
  //     final isOldCar = await _isOldCar(carInfo);
  //     if (isOldCar) {
  //       return Tuple(QrScanState.OLD, carInfo);
  //     } else {
  //       carInfoDataSource.addCarInfo(carInfo);
  //       return Tuple(QrScanState.NEW, carInfo);
  //     }
  //   } on Exception catch (e) {
  //     print("Logging: ERROR ${e.toString()}");
  //   }
  //   return Tuple(QrScanState.DAFUQ, null);
  // }
  //
  // Future<bool> _isOldCar(CarInfo carInfo) async {
  //   final allCars = await carInfoDataSource.getAllCars();
  //   return allCars.any((car) => car.name == carInfo.name);
  // }
}
