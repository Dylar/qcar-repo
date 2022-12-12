import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class CarsViewModel extends ViewModel implements FeedbackViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarsVM extends CarsViewModel with FeedbackFun {
  CarsVM(this.trackingService, this.infoService);

  @override
  TrackingService trackingService;
  InfoService infoService;

  Stream<List<CarInfo>> watchCars() => infoService.watchCarsInfo();
}
