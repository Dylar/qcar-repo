import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/mixins/feedback_fun.dart';
import 'package:qcar_business/ui/mixins/scan_fun.dart';
import 'package:qcar_business/ui/screens/cars/cars_page.dart';

abstract class QRViewModel extends ViewModel
    implements FeedbackViewModel, ScanViewModel {}

class QrVM extends QRViewModel with FeedbackFun, ScanFun {
  QrVM(this.trackingService, this.infoService);

  @override
  TrackingService trackingService;
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
}
