import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/category_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/mixins/feedback_fun.dart';
import 'package:qcar_business/ui/navigation/app_bar.dart';

abstract class VideoOverViewModel extends ViewModel
    implements AppBarViewModel, FeedbackViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedCategory;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel with FeedbackFun {
  VideoOverVM(this.trackingService, CarInfo selectedCar,
      CategoryInfo selectedCategory) {
    this.selectedCar = selectedCar;
    this.selectedCategory = selectedCategory;
  }

  @override
  TrackingService trackingService;

  Stream<List<VideoInfo>> watchVideos() async* {
    yield selectedCategory.videos;
  }
}
