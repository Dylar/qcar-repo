import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/screens/overview/car_overview_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

abstract class QRViewModel extends ViewModel {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  SellInfo? sellInfo;

  void onScan(Barcode p1);
}

class QrVM extends QRViewModel {
  InfoService infoService;

  QrVM(this.infoService);

  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  SellInfo? sellInfo;

  void onScan(Barcode barcode) {
    this.barcode = barcode;
    final data = barcode.code ?? "";
    qrState = QrScanState.SCANNING;
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      final state = await infoService.onNewScan(data);
      qrState = state.first!;
      sellInfo = state.second;
      switch (qrState) {
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
