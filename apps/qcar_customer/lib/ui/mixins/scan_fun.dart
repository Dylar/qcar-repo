import 'package:flutter/material.dart';
import 'package:qcar_customer/core/models/sale_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';
import 'package:qcar_shared/utils/logger.dart';
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
  SaleInfo? saleInfo;

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
      saleInfo = await infoService.loadSaleInfo(scanValue);
      final isOldCar =
          await infoService.isOldCar(saleInfo!.brand, saleInfo!.model);
      qrState = isOldCar ? QrScanState.OLD : QrScanState.NEW;
    } on Exception catch (e) {
      Logger.logE("Scan error: ${e.toString()}");
      qrState = QrScanState.DAFUQ;
    }

    switch (qrState) {
      case QrScanState.NEW:
        await infoService.loadCarInfo(saleInfo!);
        await infoService.upsertSaleInfo(saleInfo!);
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
