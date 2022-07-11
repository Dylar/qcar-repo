import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/service/feedback_fun.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/tracking_service.dart';

abstract class CarsViewModel extends ViewModel with FeedbackFun {
  Stream<List<CarInfo>> watchCars();
}

class CarsVM extends CarsViewModel {
  CarsVM(this.trackingService, this.infoService);

  @override
  TrackingService trackingService;
  InfoService infoService;

  Stream<List<CarInfo>> watchCars() {
    return infoService.carInfoDataSource.watchCarInfo();
  }
}
