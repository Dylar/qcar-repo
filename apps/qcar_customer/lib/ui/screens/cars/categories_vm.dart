import 'dart:async';

import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/category_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/navigation/app_bar.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';

abstract class CategoriesViewModel extends ViewModel
    implements AppBarViewModel, FeedbackViewModel {
  String get title;

  List<CategoryInfo> get categories;

  void selectCategory(CategoryInfo category);
}

class CategoriesVM extends CategoriesViewModel with FeedbackFun {
  CategoriesVM(this.trackingService, this._infoService, this.selectedCar);

  @override
  TrackingService trackingService;
  final InfoService _infoService;

  CarInfo selectedCar;

  String get title => "${selectedCar.brand} ${selectedCar.model}";

  List<CategoryInfo> get categories =>
      selectedCar.categories..sort((a, b) => a.order.compareTo(b.order));

  late final StreamSubscription<List<CarInfo>> sub;

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Future init() async {
    sub = _infoService.watchCarInfo().listen((cars) {
      selectedCar = cars.firstWhere((car) =>
          car.model == selectedCar.model && car.brand == selectedCar.brand);
      notifyListeners();
    });
  }

  void selectCategory(CategoryInfo category) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, category));
  }
}
