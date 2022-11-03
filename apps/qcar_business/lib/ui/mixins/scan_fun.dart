import 'package:flutter/material.dart';
import 'package:qcar_business/core/misc/helper/logger.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/notify/dialog.dart';
import 'package:qcar_business/ui/notify/snackbars.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING, SCANNING }

abstract class ScanViewModel {
  QrScanState get qrState;

  Future onScan(Barcode scan);
  void doOnScanState(QrScanState qrState);
}

mixin ScanFun implements ScanViewModel {
  InfoService get infoService;

  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  SellInfo? sellInfo;

  late void Function() notifyListeners;
  late Future Function(Function(BuildContext)) openDialog;
  late Future Function(Function(BuildContext)) showSnackBar;

  void doOnScanState(QrScanState qrState);

  Future onScan(Barcode scan) async {
    Logger.logI("scan: ${scan.code}");
    final scanValue = scan.code;
    if (scanValue == null || qrState == QrScanState.SCANNING) {
      return;
    }
    qrState = QrScanState.SCANNING;
    notifyListeners();

    //hint: yea we need a delay to disable the camera/qrscan
    await Future.delayed(Duration(milliseconds: 10));

    try {
      sellInfo = await infoService.loadSellInfo(scanValue);
      final isOldCar =
          await infoService.isOldCar(sellInfo!.brand, sellInfo!.model);
      qrState = isOldCar ? QrScanState.OLD : QrScanState.NEW;
    } on Exception catch (e) {
      Logger.logE("scan error: ${e.toString()}");
      qrState = QrScanState.DAFUQ;
    }

    switch (qrState) {
      case QrScanState.NEW:
        await infoService.loadCarInfo(sellInfo!);
        await infoService.upsertSellInfo(sellInfo!);
        break;
      case QrScanState.OLD:
        showSnackBar(oldCarScannedSnackBar);
        break;
      case QrScanState.DAFUQ:
        openDialog(scanErrorDialog);
        break;
      default:
        break;
    }

    doOnScanState(qrState);
    notifyListeners();
  }
}