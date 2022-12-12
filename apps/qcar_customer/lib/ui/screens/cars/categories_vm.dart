import 'dart:async';

import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/category_info.dart';
import 'package:qcar_customer/core/models/favorite.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/navigation/app_bar.dart';
import 'package:qcar_customer/ui/screens/cars/favorites_button.dart';
import 'package:qcar_customer/ui/screens/video/favorites_page.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class CategoriesViewModel extends ViewModel
    implements AppBarViewModel, FeedbackViewModel, FavoritesButtonViewModel {
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
  @override
  bool hasFavorites = false;

  String get title => "${selectedCar.brand} ${selectedCar.model}";

  List<CategoryInfo> get categories =>
      selectedCar.categories..sort((a, b) => a.order.compareTo(b.order));

  late final StreamSubscription<CarInfo> carSub;
  late final StreamSubscription<Iterable<Favorite>> favSub;

  @override
  void dispose() {
    super.dispose();
    carSub.cancel();
    favSub.cancel();
  }

  @override
  Future init() async {
    carSub = _infoService.watchCarInfo(selectedCar).listen((car) {
      selectedCar = car;
      notifyListeners();
    });

    favSub = _infoService.watchFavorites(selectedCar).listen((favs) {
      hasFavorites = favs.isNotEmpty;
      notifyListeners();
    });
  }

  void selectCategory(CategoryInfo category) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, category));
  }

  void naviToFavorites() {
    navigateTo(FavoritesPage.pushIt(selectedCar));
  }
}
