import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/screens/intro/loading_page.dart';
import 'package:qcar_customer/ui/viewmodels/intro_vm.dart';
import 'package:qcar_customer/ui/widgets/debug/debug_skip_button.dart';
import 'package:qcar_customer/ui/widgets/qr_camera_view.dart';

class IntroPage extends View<IntroViewModel> {
  static const String routeName = "/introPage";

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
    String status = "";
    switch (viewModel.qrState) {
      case QrScanState.NEW:
      case QrScanState.OLD:
        break;
      case QrScanState.DAFUQ:
        status = l10n.introPageMessageError;
        break;
      case QrScanState.WAITING:
        status = l10n.introPageMessage;
        break;
      case QrScanState.SCANNING:
        status = l10n.introPageMessageScanning;
        break;
    }
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(child: Text(status)),
        ),
        Expanded(
          flex: 7,
          child: viewModel.qrState == QrScanState.SCANNING
              ? AppLoadingIndicator(viewModel.progressValue)
              : QRCameraView(
                  (barcode) {
                    setState(() {
                      viewModel.onScan(barcode.code ?? "");
                    });
                  },
                ),
        ),
        if (EnvironmentConfig.isDev)
          SkipDebugButton(context.read<IntroProvider>().viewModel.onScan),
      ],
    );
  }
}
