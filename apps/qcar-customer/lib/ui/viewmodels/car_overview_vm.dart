import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:provider/provider.dart';

class CarOverViewModelProvider
    extends ChangeNotifierProvider<CarOverViewProvider> {
  CarOverViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => CarOverViewProvider(CarOverVM(carInfoService)));
}

class CarOverViewProvider extends ViewModelProvider<CarOverViewModel> {
  CarOverViewProvider(CarOverViewModel viewModel) : super(viewModel);
}

abstract class CarOverViewModel extends ViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarOverVM extends CarOverViewModel {
  CarInfoService carInfoService;

  CarOverVM(this.carInfoService);

  @override
  Stream<List<CarInfo>> watchCars() {
    return carInfoService.carInfoDataSource.watchCarInfo();
  }
}
