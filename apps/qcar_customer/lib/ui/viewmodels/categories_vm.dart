import 'dart:async';

import 'package:qcar_customer/core/navigation/app_bar.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/mixins/feedback_fun.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';

abstract class CategoriesViewModel extends ViewModel
    with FeedbackFun
    implements AppBarViewModel {
  String get title;
  List<CategoryInfo> get categories;

  void selectCategory(CategoryInfo category);
}

class CategoriesVM extends CategoriesViewModel {
  CategoriesVM(this.uploadService, this._infoService, this.selectedCar);

  @override
  UploadService uploadService;
  final InfoService _infoService;

  CarInfo selectedCar;

  String get title => "${selectedCar.brand} ${selectedCar.model}";
  List<CategoryInfo> get categories =>
      selectedCar.categories..sort((a, b) => a.order.compareTo(b.order));

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

  void selectCategory(CategoryInfo category) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, category));
  }
}
