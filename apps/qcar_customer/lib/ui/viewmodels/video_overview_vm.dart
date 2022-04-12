import 'package:provider/provider.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/video_info.dart';

class VideoOverViewModelProvider
    extends ChangeNotifierProvider<VideoOverViewProvider> {
  VideoOverViewModelProvider()
      : super(create: (_) => VideoOverViewProvider(VideoOverVM()));
}

class VideoOverViewProvider extends ViewModelProvider<VideoOverViewModel> {
  VideoOverViewProvider(VideoOverViewModel viewModel) : super(viewModel);
}

abstract class VideoOverViewModel extends ViewModel {
  late CarInfo selectedCar;
  late CategoryInfo selectedDir;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoOverVM();

  @override
  Stream<List<VideoInfo>> watchVideos() async* {
    yield selectedDir.videos;
  }
}
