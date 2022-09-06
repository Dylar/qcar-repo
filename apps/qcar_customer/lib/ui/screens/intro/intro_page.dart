import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/ui/mixins/scan_fun.dart';
import 'package:qcar_customer/ui/screens/intro/intro_vm.dart';
import 'package:qcar_customer/ui/screens/intro/loading_page.dart';
import 'package:qcar_customer/ui/widgets/debug/debug_skip_button.dart';
import 'package:qcar_customer/ui/widgets/qr_camera_view.dart';

class IntroPage extends View<IntroViewModel> {
  static const String routeName = "/introPage";

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  IntroPage.model(IntroViewModel viewModel) : super.model(viewModel);

  @override
  State<IntroPage> createState() => _IntroScanPageState(viewModel);
}

class _IntroScanPageState extends ViewState<IntroPage, IntroViewModel> {
  _IntroScanPageState(IntroViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.introPageTitle)),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: <Widget>[
        Expanded(child: Center(child: Text(_statusText(l10n)))),
        Expanded(
          flex: 7,
          child: viewModel.qrState == QrScanState.SCANNING
              ? AppLoadingIndicator(viewModel.progressValue)
              : QRCameraView(viewModel.onScan),
        ),
        if (EnvironmentConfig.isDev) SkipDebugButton(viewModel.onScan),
      ],
    );
  }

  String _statusText(AppLocalizations l10n) {
    String status = "";
    switch (viewModel.qrState) {
      case QrScanState.NEW:
      case QrScanState.OLD:
        break;
      case QrScanState.WAITING:
      case QrScanState.DAFUQ:
        status = l10n.introPageMessage;
        break;
      case QrScanState.SCANNING:
        status = l10n.introPageMessageScanning;
        break;
    }
    return status;
  }
}
