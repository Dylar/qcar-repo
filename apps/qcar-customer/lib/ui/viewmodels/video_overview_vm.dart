import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:provider/provider.dart';

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
