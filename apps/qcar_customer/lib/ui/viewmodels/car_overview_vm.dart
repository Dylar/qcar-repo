import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/service/info_service.dart';

abstract class CarsViewModel extends ViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarsVM extends CarsViewModel {
  CarsVM(this.infoService);

  InfoService infoService;

  Stream<List<CarInfo>> watchCars() {
    return infoService.carInfoDataSource.watchCarInfo();
  }
}
