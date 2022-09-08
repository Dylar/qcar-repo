import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/mixins/scan_fun.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';

abstract class QRViewModel extends ViewModel
    implements FeedbackViewModel, ScanViewModel {}

class QrVM extends QRViewModel with FeedbackFun, ScanFun {
  QrVM(this.uploadService, this.infoService);

  @override
  UploadService uploadService;
  InfoService infoService;

  @override
  void doOnScanState(QrScanState qrState) {
    switch (qrState) {
      case QrScanState.NEW:
        navigateTo(CarsPage.popAndPush());
        break;
      default:
        break;
    }
  }

// Widget buildScanInfo() {
//   final state = viewModel.qrState;
//   final carInfo = viewModel.sellInfo;
//   final barcode = viewModel.barcode;
//   switch (state) {
//     case QrScanState.NEW:
//       text = "Yeah neues Auto";
//       break;
//     case QrScanState.OLD:
//       text = 'Das Auto ${carInfo!.model} hast du schon';
//       break;
//     case QrScanState.DAFUQ:
//       text = barcode == null
//           ? "Unbekannter Fehler"
//           : 'Barcode Type: ${describeEnum(barcode.format)}\nData: ${barcode.code}';
//       break;
//     case QrScanState.WAITING:
//       text = 'Bitte einen QR Code scannen';
//       break;
//     case QrScanState.SCANNING:
//       text = 'Scanning...';
//       break;
//   }
//   return ;
// }
}
