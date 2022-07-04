import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/video_info.dart';

abstract class VideoOverViewModel extends ViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedDir;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoOverVM(CarInfo selectedCar, CategoryInfo selectedDir) {
    this.selectedCar = selectedCar;
    this.selectedDir = selectedDir;
  }

  Stream<List<VideoInfo>> watchVideos() async* {
    yield selectedDir.videos;
  }
}
