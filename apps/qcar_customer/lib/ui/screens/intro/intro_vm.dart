import 'package:flutter/material.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/mixins/scan_fun.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../home/home_page.dart';

abstract class IntroViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>> get progressValue;

  SellInfo? sellInfo;

  Barcode? barcode;
  QrScanState qrState = QrScanState.WAITING;

  void onScan(String scan);
}

class IntroVM extends IntroViewModel {
  IntroVM(this.infoService);

  InfoService infoService;

  ValueNotifier<Tuple<double, double>> get progressValue =>
      infoService.progressValue;

  @override
  void onScan(String scan) {
    if (qrState == QrScanState.SCANNING) {
      return;
    }
    qrState = QrScanState.SCANNING;
    notifyListeners();
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      final state = await infoService.onNewScan(scan);
      qrState = state.firstOrThrow;
      sellInfo = state.second;
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
      notifyListeners();
    });
  }
}
