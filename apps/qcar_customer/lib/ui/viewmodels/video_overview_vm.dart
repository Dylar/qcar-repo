import 'package:qcar_customer/core/navigation/app_bar.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/video_info.dart';

abstract class VideoOverViewModel extends ViewModel implements AppBarViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedCategory;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoOverVM(CarInfo selectedCar, CategoryInfo selectedCategory) {
    this.selectedCar = selectedCar;
    this.selectedCategory = selectedCategory;
  }

  Stream<List<VideoInfo>> watchVideos() async* {
    yield selectedCategory.videos;
  }
}
