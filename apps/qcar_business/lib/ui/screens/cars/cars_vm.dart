import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/mixins/feedback_fun.dart';

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
