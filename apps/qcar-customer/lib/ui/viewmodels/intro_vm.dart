import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/sell_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../screens/home/home_page.dart';

class IntroViewModelProvider extends ChangeNotifierProvider<IntroProvider> {
  IntroViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => IntroProvider(IntroVM(carInfoService)));
}

class IntroProvider extends ViewModelProvider<IntroViewModel> {
  IntroProvider(IntroViewModel viewModel) : super(viewModel);
}

abstract class IntroViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>> get progressValue;

  QrScanState get qrState;

  Barcode? get barcode;

  SellInfo? get sellInfo;

  void onScan(String scan);
}

class _IntroVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  SellInfo? carInfo;
}

class IntroVM extends IntroViewModel {
  CarInfoService carInfoService;

  IntroVM(this.carInfoService);

  final _IntroVMState _state = _IntroVMState();

  @override
  ValueNotifier<Tuple<double, double>> get progressValue =>
      carInfoService.progressValue;

  @override
  QrScanState get qrState => _state.qrState;

  @override
  Barcode? get barcode => _state.barcode;

  @override
  SellInfo? get sellInfo => _state.carInfo;

  @override
  void onScan(String scan) {
    if (_state.qrState == QrScanState.SCANNING) {
      return;
    }
    _state.qrState = QrScanState.SCANNING;
    notifyListeners();
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      final state = await carInfoService.onNewScan(scan);
      _state.qrState = state.firstOrThrow;
      _state.carInfo = state.second;
      switch (_state.qrState) {
        case QrScanState.OLD:
          //hint: only on debug accessible
          navigateTo(HomePage.replaceWith());
          break;
        case QrScanState.NEW:
          navigateTo(HomePage.replaceWith());
          break;
        case QrScanState.DAFUQ:
        case QrScanState.WAITING:
        case QrScanState.SCANNING:
          break;
      }
      notifyListeners();
    });
  }
}
