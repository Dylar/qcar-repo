import 'dart:async';

import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';

abstract class DirViewModel extends ViewModel {
  String get title;

  late CarInfo selectedCar;

  List<CategoryInfo> getDirs();

  void selectDir(CategoryInfo dir);
}

class DirVM extends DirViewModel {
  DirVM(this._infoService, CarInfo selectedCar) {
    this.selectedCar = selectedCar;
  }

  final InfoService _infoService;

  String get title => "${selectedCar.brand} ${selectedCar.model}";

  late final StreamSubscription<List<CarInfo>> sub;

  @override
  void init() {
    super.init();
    sub = _infoService.watchCarInfo().listen((cars) {
      selectedCar = cars.firstWhere((car) =>
          car.model == selectedCar.model && car.brand == selectedCar.brand);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  List<CategoryInfo> getDirs() {
    return selectedCar.categories..sort((a, b) => a.order.compareTo(b.order));
  }

  void selectDir(CategoryInfo dir) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, dir));
  }
}
