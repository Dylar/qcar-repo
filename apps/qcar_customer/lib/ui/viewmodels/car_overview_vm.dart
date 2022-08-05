import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/mixins/feedback_fun.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/upload_service.dart';

abstract class CarsViewModel extends ViewModel with FeedbackFun {
  Stream<List<CarInfo>> watchCars();
}

class CarsVM extends CarsViewModel {
  CarsVM(this.uploadService, this.infoService);

  @override
  UploadService uploadService;
  InfoService infoService;

  Stream<List<CarInfo>> watchCars() {
    return infoService.carInfoDataSource.watchCarInfo();
  }
}
