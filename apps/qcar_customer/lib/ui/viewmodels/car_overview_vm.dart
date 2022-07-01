import 'package:provider/provider.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/service/info_service.dart';

class CarOverViewModelProvider
    extends ChangeNotifierProvider<CarOverViewProvider> {
  CarOverViewModelProvider(InfoService carInfoService)
      : super(create: (_) => CarOverViewProvider(CarOverVM(carInfoService)));
}

class CarOverViewProvider extends ViewModelProvider<CarOverViewModel> {
  CarOverViewProvider(CarOverViewModel viewModel) : super(viewModel);
}

abstract class CarOverViewModel extends ViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarOverVM extends CarOverViewModel {
  InfoService carInfoService;

  CarOverVM(this.carInfoService);

  @override
  Stream<List<CarInfo>> watchCars() {
    return carInfoService.carInfoDataSource.watchCarInfo();
  }
}
