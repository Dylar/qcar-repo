import 'package:qcar_customer/core/navigation/app_bar.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';

abstract class VideoOverViewModel extends ViewModel
    with FeedbackFun
    implements AppBarViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedCategory;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoOverVM(
      this.uploadService, CarInfo selectedCar, CategoryInfo selectedCategory) {
    this.selectedCar = selectedCar;
    this.selectedCategory = selectedCategory;
  }

  @override
  UploadService uploadService;

  Stream<List<VideoInfo>> watchVideos() async* {
    yield selectedCategory.videos;
  }
}
