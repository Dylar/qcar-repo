import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';

abstract class CarsViewModel extends ViewModel implements FeedbackViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarsVM extends CarsViewModel with FeedbackFun {
  CarsVM(this.uploadService, this.infoService);

  @override
  UploadService uploadService;
  InfoService infoService;

  Stream<List<CarInfo>> watchCars() {
    return infoService.watchCarInfo();
  }
}
