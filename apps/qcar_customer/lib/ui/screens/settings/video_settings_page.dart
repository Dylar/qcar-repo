import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/models/model_data.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/error_widget.dart';
import 'package:qcar_shared/widgets/loading_overlay.dart';
import 'package:settings_ui/settings_ui.dart';

class VideoSettingsPage extends View<SettingsViewModel> {
  static const String routeName = "/videoSettingsPage";

  VideoSettingsPage(SettingsViewModel viewModel) : super.model(viewModel);

  static AppRouteSpec pushIt(SettingsViewModel model) => AppRouteSpec(
      name: routeName,
      action: AppRouteAction.pushTo,
      arguments: {ARGS_VIEW_MODEL: model});

  @override
  State<VideoSettingsPage> createState() => _VideoSettingsPageState(viewModel);
}

class _VideoSettingsPageState
    extends ViewState<VideoSettingsPage, SettingsViewModel> {
  _VideoSettingsPageState(SettingsViewModel viewModel) : super(viewModel);

  Map<String, bool>? settingsMap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () => _openConfirmDialog(context, l10n),
      child: Scaffold(
        appBar: AppBar(title: Text("Video Einstellungen")),
        body: FutureBuilder<void>(
            future: viewModel.isInitialized,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorInfoWidget(snapshot.error!);
              }

              if (snapshot.connectionState != ConnectionState.done) {
                return LoadingOverlay();
              }
              if (settingsMap == null) {
                settingsMap = Map.from(viewModel.settings.videos);
              }
              return _buildPage(l10n);
            }),
        persistentFooterButtons: [
          Container(
            height: 48,
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () async {
                if (settingsMap != null) {
                  await viewModel.saveVideoSettings(settingsMap!);
                }
                Navigate.pop(context);
              },
              child: Text(l10n.save),
            ),
          )
        ],
      ),
    );
  }

  SettingsTile _buildSwitch(String title, String key, IconData icon) =>
      SettingsTile.switchTile(
        onToggle: (value) async => setState(() => settingsMap![key] = value),
        initialValue: settingsMap![key],
        leading: Icon(icon),
        title: Text(title),
      );

  Widget _buildPage(AppLocalizations l10n) => SettingsList(
        sections: [
          SettingsSection(
            title: Text('Wiedergabe'),
            tiles: <SettingsTile>[
              _buildSwitch(l10n.autoPlay, "autoPlay", Icons.play_arrow),
              _buildSwitch("Wiederholen", "looping", Icons.repeat),
            ],
          ),
          SettingsSection(
            title: Text('Steuerung'),
            tiles: <SettingsTile>[
              _buildSwitch("Immer zeigen", "showControlsOnInitialize",
                  Icons.call_to_action_outlined),
            ],
          ),
        ],
      );

  Future<bool> _openConfirmDialog(
      BuildContext context, AppLocalizations l10n) async {
    print("_openConfirmDialog");
    if (mapEquals(settingsMap, viewModel.settings.videos)) {
      print("nothign changed");
      return true;
    }
    print("save it?");
    final save = await openConfirmDialog(
        context, l10n.notSavedTitle, l10n.notSavedMessage);
    if (save) {
      print("save it!");
      await viewModel.saveVideoSettings(settingsMap!);
    }
    print("_openConfirmDialog done");
    return true;
  }
}
