import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/viewmodels/qr_vm.dart';
import 'package:qcar_customer/ui/widgets/qr_camera_view.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

class QrScanPage extends View<QRViewModel> {
  QrScanPage(QRViewModel viewModel, {Key? key}) : super.model(viewModel);

  static const String routeName = "/qrScanPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  @override
  State<QrScanPage> createState() => _QrScanPageState(viewModel);
}

class _QrScanPageState extends ViewState<QrScanPage, QRViewModel> {
  _QrScanPageState(QRViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qrScanPageTitle),
      ),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(QrScanPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: viewModel.qrState == QrScanState.SCANNING
              ? VideoDownload()
              : QRCameraView(viewModel.onScan),
        ),
        Expanded(flex: 1, child: buildScanInfo())
      ],
    );
  }

  Widget buildScanInfo() {
    final state = viewModel.qrState;
    final carInfo = viewModel.sellInfo;
    final barcode = viewModel.barcode;
    String text;
    switch (state) {
      case QrScanState.NEW:
        text = "Yeah neues Auto";
        break;
      case QrScanState.OLD:
        text = 'Das Auto ${carInfo!.model} hast du schon';
        break;
      case QrScanState.DAFUQ:
        text = barcode == null
            ? "Unbekannter Fehler"
            : 'Barcode Type: ${describeEnum(barcode.format)}\nData: ${barcode.code}';
        break;
      case QrScanState.WAITING:
        text = 'Bitte einen QR Code scannen';
        break;
      case QrScanState.SCANNING:
        text = 'Scanning...';
        break;
    }
    return Center(child: Text(text));
  }
}
