import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/navigation/app_bar.dart';

abstract class FavoritesViewModel extends ViewModel
    implements AppBarViewModel, FeedbackViewModel {
  late CarInfo selectedCar;

  Stream<List<VideoInfo>> watchVideos();
}

class FavoritesVM extends FavoritesViewModel with FeedbackFun {
  FavoritesVM(this.trackingService, this._infoService, CarInfo selectedCar) {
    this.selectedCar = selectedCar;
  }

  @override
  TrackingService trackingService;

  InfoService _infoService;

  Stream<List<VideoInfo>> watchVideos() async* {
    final favs = await _infoService.getFavorites(selectedCar);
    yield selectedCar.categories.fold(<VideoInfo>[], (result, cat) {
      return result
        ..addAll(cat.videos.where((vid) => favs
            .any((fav) => fav.category == cat.name && fav.video == vid.name)));
    });
  }
}
