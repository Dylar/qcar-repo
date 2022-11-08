import 'dart:async';

import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/notify/snackbars.dart';
import 'package:qcar_business/ui/screens/form/form_videos_page.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class FormViewModel extends ViewModel {
  bool get validateError;

  List<CarInfo> get cars;

  List<VideoInfo> get videos;

  bool isSelected(String category, VideoInfo? video);

  void selectCar(CarInfo car);

  void selectVideo(String category, VideoInfo? video);

  void saveSellInfo(CustomerInfo customer);
}

class FormVM extends FormViewModel {
  FormVM(this.authService, this.infoService);

  final AuthenticationService authService;
  final InfoService infoService;

  List<CarInfo> cars = [];
  List<VideoInfo> _videos = [];

  List<VideoInfo> get videos => _videos
      .where((video) =>
          video.model == selectedCar!.model &&
          video.brand == selectedCar!.brand)
      .toList();

  CarInfo? selectedCar;
  Map<String, List<VideoInfo>> selectedVideos = {};

  bool validateError = false;

  @override
  Future init() async {
    if (cars.isEmpty) {
      cars = infoService.cars;
      _videos = infoService.getVideos();
    }
  }

  @override
  bool isSelected(String category, VideoInfo? video) {
    final selectedVids = selectedVideos[category] ?? [];
    if (selectedVids.isEmpty) {
      return false;
    }

    if (video == null) {
      final allVids = videos.where((vid) => vid.category == category);
      return allVids.length == selectedVids.length;
    } else {
      return selectedVids.contains(video);
    }
  }

  @override
  void selectCar(CarInfo car) {
    selectedCar = car;
    selectedVideos.clear();
    videos.forEach((video) {
      final list = selectedVideos[video.category] ?? [];
      list.add(video);
      selectedVideos[video.category] = list;
    });
    navigateTo(FormVideosPage.pushIt(this));
  }

  @override
  void selectVideo(String category, VideoInfo? video) {
    final list = selectedVideos[category] ?? [];
    if (video == null) {
      isSelected(category, video)
          ? list.clear()
          : list.addAll(videos.where((vid) => vid.category == category));
    } else {
      isSelected(category, video) ? list.remove(video) : list.add(video);
    }
    selectedVideos[category] = list;
    notifyListeners();
  }

  @override
  void saveSellInfo(CustomerInfo customer) {
    if (customer.name.isEmpty ||
        customer.lastName.isEmpty ||
        customer.email.isEmpty ||
        customer.birthday.isEmpty) {
      validateError = true;
      showSnackBar(showNonOptionalErrorSnackBar);
      notifyListeners();
      return;
    }

    SellInfo info = SellInfo(
      seller: authService.currentUser,
      car: selectedCar!,
      videos: selectedVideos,
      customer: customer,
    );
    infoService.sellCar(info);
    navigateTo(HomePage.onSellSaving());
  }
}
