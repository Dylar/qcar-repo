import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/mixins/scan_fun.dart';
import 'package:qcar_business/ui/navigation/navi.dart';
import 'package:qcar_business/ui/screens/app/loading_page.dart';
import 'package:qcar_business/ui/screens/intro/intro_vm.dart';
import 'package:qcar_business/ui/widgets/debug/debug_skip_button.dart';
import 'package:qcar_business/ui/widgets/error_widget.dart';
import 'package:qcar_business/ui/widgets/info_widget.dart';
import 'package:qcar_business/ui/widgets/qr_camera_view.dart';

class IntroPage extends View<IntroViewModel> {
  static const String routeName = "/introPage";

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  IntroPage(IntroViewModel viewModel) : super.model(viewModel);

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
    return FutureBuilder(
        future: viewModel.isInitialized,
        builder: (context, snap) {
          if (snap.hasError) {
            return ErrorInfoWidget(snap.error!);
          }

          if (snap.connectionState != ConnectionState.done) {
            return AppLoadingIndicator(viewModel.progressValue);
          }

          return Column(
            children: <Widget>[
              Expanded(
                flex: 70,
                child: viewModel.qrState == QrScanState.SCANNING
                    ? AppLoadingIndicator(viewModel.progressValue)
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
              if (EnvironmentConfig.isDev) SkipDebugButton(viewModel.onScan),
            ],
          );
        });
  }

  String _statusText(AppLocalizations l10n) {
    String status = "";
    switch (viewModel.qrState) {
      case QrScanState.WAITING:
      case QrScanState.DAFUQ:
        status = l10n.introPageMessage;
        break;
      case QrScanState.SCANNING:
        status = l10n.introPageMessageScanning;
        break;
      case QrScanState.NEW:
      case QrScanState.OLD:
        break;
    }
    return status;
  }
}
