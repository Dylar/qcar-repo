import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/mixins/scan_fun.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

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
