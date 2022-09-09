import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/category_info.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/navigation/app_bar.dart';

abstract class VideoOverViewModel extends ViewModel
    implements AppBarViewModel, FeedbackViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedCategory;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel with FeedbackFun {
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
