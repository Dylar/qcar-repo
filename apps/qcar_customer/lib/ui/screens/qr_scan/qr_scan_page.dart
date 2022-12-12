import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/ui/mixins/scan_fun.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_vm.dart';
import 'package:qcar_customer/ui/widgets/qr_camera_view.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/info_widget.dart';

class QrScanPage extends View<QRViewModel> {
  QrScanPage(QRViewModel viewModel, {Key? key}) : super.model(viewModel);

  static const String routeName = "/qrScanPage";

  static RoutingSpec pushIt() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
      );

  static RoutingSpec popAndPush() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.popAndPushTo,
      );

  @override
  State<QrScanPage> createState() => _QrScanPageState(viewModel);
}

class _QrScanPageState extends ViewState<QrScanPage, QRViewModel> {
  _QrScanPageState(QRViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.qrScanPageTitle)),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 70,
            child: viewModel.qrState == QrScanState.SCANNING
                ? Center(child: CircularProgressIndicator())
                : QRCameraView(viewModel.onScan),
          ),
          Spacer(flex: 5),
          Flexible(
            flex: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InfoWidget(_statusText(l10n)),
            ),
          ),
          Spacer(flex: 5),
        ],
      ),
      bottomNavigationBar: AppNavigation(viewModel, QrScanPage.routeName),
    );
  }

  String _statusText(AppLocalizations l10n) {
    String status = "";
    switch (viewModel.qrState) {
      case QrScanState.OLD:
      case QrScanState.WAITING:
        status = l10n.qrScanPageMessage;
        break;
      case QrScanState.DAFUQ:
        status = l10n.scanError;
        break;
      case QrScanState.SCANNING:
        status = l10n.introPageMessageScanning;
        break;
      case QrScanState.NEW:
        break;
    }
    return status;
  }
}
