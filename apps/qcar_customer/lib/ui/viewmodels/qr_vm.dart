import 'package:provider/provider.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/screens/overview/car_overview_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrViewModelProvider extends ChangeNotifierProvider<QrProvider> {
  QrViewModelProvider(InfoService carInfoService)
      : super(create: (_) => QrProvider(QrVM(carInfoService)));
}

class QrProvider extends ViewModelProvider<QrViewModel> {
  QrProvider(QrViewModel viewModel) : super(viewModel);
}

abstract class QrViewModel extends ViewModel {
  QrScanState get qrState;

  Barcode? get barcode;

  SellInfo? get sellInfo;

  void onScan(Barcode barcode);
}

class _QrVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  SellInfo? sellInfo;
}

class QrVM extends QrViewModel {
  InfoService carInfoService;

  QrVM(this.carInfoService);

  final _QrVMState _state = _QrVMState();

  @override
  QrScanState get qrState => _state.qrState;

  @override
  Barcode? get barcode => _state.barcode;

  @override
  SellInfo? get sellInfo => _state.sellInfo;

  @override
  void onScan(Barcode barcode) {
    this._state.barcode = barcode;
    final data = barcode.code ?? "";
    _state.qrState = QrScanState.SCANNING;
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      final state = await carInfoService.onNewScan(data);
      _state.qrState = state.first!;
      _state.sellInfo = state.second;
      switch (_state.qrState) {
        case QrScanState.NEW:
          navigateTo(CarOverviewPage.popAndPush());
          break;
        case QrScanState.OLD:
        case QrScanState.DAFUQ:
        case QrScanState.WAITING:
        case QrScanState.SCANNING:
          break;
      }

      notifyListeners();
    });
  }
}
