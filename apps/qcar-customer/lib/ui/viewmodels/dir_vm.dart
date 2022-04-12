import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:carmanual/ui/screens/video/video_overview_page.dart';
import 'package:provider/provider.dart';

class DirViewModelProvider extends ChangeNotifierProvider<DirViewProvider> {
  DirViewModelProvider() : super(create: (_) => DirViewProvider(DirVM()));
}

class DirViewProvider extends ViewModelProvider<DirViewModel> {
  DirViewProvider(DirViewModel viewModel) : super(viewModel);
}

abstract class DirViewModel extends ViewModel {
  String get title;

  late CarInfo selectedCar;

  List<CategoryInfo> getDirs();

  void selectDir(CategoryInfo dir);
}

class DirVM extends DirViewModel {
  DirVM();

  // final VideoInfoDataSource _videoSource;

  late CarInfo selectedCar;

  List<VideoInfo> videos = [];

  @override
  String get title => "${selectedCar.brand} ${selectedCar.model}";

  @override
  List<CategoryInfo> getDirs() {
    return selectedCar.categories..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  void selectDir(CategoryInfo dir) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, dir));
  }
}
