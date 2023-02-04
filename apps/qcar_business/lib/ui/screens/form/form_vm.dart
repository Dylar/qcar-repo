import 'dart:async';

import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/notify/dialog.dart';
import 'package:qcar_business/ui/notify/snackbars.dart';
import 'package:qcar_business/ui/screens/form/form_videos_page.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';
import 'package:qcar_shared/utils/time_utils.dart';

abstract class FormViewModel extends ViewModel {
  bool get validateError;

  List<CarInfo> get cars;

  void selectCar(CarInfo car);

  List<VideoInfo> get videos;

  void selectVideo(String category, VideoInfo? video);

  bool isVideoSelected(String category, VideoInfo? video);

  CustomerInfo customer = CustomerInfo.empty();

  DateTime? get selectedBirthday;

  set selectBirthday(DateTime selectBirthday);

  void saveSaleInfo();
}

class FormVM extends FormViewModel {
  FormVM(this.authService, this.infoService);

  final AuthenticationService authService;
  final InfoService infoService;

  List<CarInfo> cars = [];
  CarInfo? selectedCar;

  List<VideoInfo> _videos = [];

  List<VideoInfo> get videos => _videos
      .where((video) =>
          video.model == selectedCar!.model &&
          video.brand == selectedCar!.brand)
      .toList();
  Map<String, List<VideoInfo>> selectedVideos = {};

  bool validateError = false;

  @override
  Future init() async {
    if (cars.isEmpty) {
      cars = infoService.getCars();
      _videos = infoService.getVideos();
    }
  }

  //--------CARS--------\\

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

  //--------VIDEOS--------\\

  @override
  void selectVideo(String category, VideoInfo? video) {
    final list = selectedVideos[category] ?? [];
    if (video == null) {
      isVideoSelected(category, video)
          ? list.clear()
          : list.addAll(videos.where((vid) => vid.category == category));
    } else {
      isVideoSelected(category, video) ? list.remove(video) : list.add(video);
    }
    selectedVideos[category] = list;
    notifyListeners();
  }

  @override
  bool isVideoSelected(String category, VideoInfo? video) {
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

  //--------CUSTOMER--------\\

  @override
  set customer(CustomerInfo info) {
    super.customer = info.copy(dealer: authService.currentDealer.name);
    notifyListeners();
  }

  @override
  DateTime? get selectedBirthday =>
      customer.birthday.isEmpty ? null : parseDate(customer.birthday);

  @override
  set selectBirthday(DateTime selectBirthday) {
    final formatted = formatDate(selectBirthday);
    if (customer.birthday != formatted) {
      customer = customer.copy(birthday: formatted);
    }
  }

  //--------SAVE--------\\

  @override
  void saveSaleInfo() {
    if (customer.name.isEmpty ||
        customer.lastName.isEmpty ||
        customer.email.isEmpty ||
        customer.birthday.isEmpty) {
      validateError = true;
      showSnackBar(showNonOptionalErrorSnackBar);
      notifyListeners();
      return;
    }

    SaleInfo info = SaleInfo(
      seller: authService.currentSeller,
      car: selectedCar!,
      videos: selectedVideos.map(
          (key, value) => MapEntry(key, value.map((e) => e.name).toList())),
      customer: customer,
    );
    infoService.sellCar(info).then((success) {
      if (success) {
        navigateTo(HomePage.onSaleSaving());
      } else {
        // TODO make real error dialog
        openDialog((ctx) => openErrorDialog(ctx, "Upload error"));
      }
    });
  }
}
