import 'package:flutter/material.dart';
import 'package:qcar_customer/core/misc/helper/tuple.dart';
import 'package:qcar_customer/core/models/sell_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/scan_fun.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

abstract class IntroViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>> get progressValue;

  SellInfo? sellInfo;

  Barcode? barcode;
  QrScanState qrState = QrScanState.WAITING;

  void onScan(Barcode scan);
}

class IntroVM extends IntroViewModel with ScanFun {
  IntroVM(this.settingsService, this.infoService);

  InfoService infoService;
  SettingsService settingsService;

  ValueNotifier<Tuple<double, double>> get progressValue =>
      infoService.progressValue;

  @override
  Future init() async {
    super.init();

    if (!await settingsService.isTrackingDecided()) {
      final trackingEnabled = await openDialog(openDecideTrackingDialog);
      await settingsService.setTrackingEnabled(trackingEnabled);
    }
  }

  @override
  void doOnScanState(QrScanState qrState) {
    switch (qrState) {
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
  }
}
