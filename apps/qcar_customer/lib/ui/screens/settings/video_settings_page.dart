import 'package:flutter/material.dart';
import 'package:qcar_customer/core/models/model_data.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/loading_overlay.dart';
import 'package:settings_ui/settings_ui.dart';

class VideoSettingsPage extends View<SettingsViewModel> {
  static const String routeName = "/videoSettingsPage";

  VideoSettingsPage.model(SettingsViewModel viewModel) : super.model(viewModel);

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
    return Scaffold(
      appBar: AppBar(title: Text("VideoSettings")),
      body: FutureBuilder<void>(
          future: viewModel.isInitialized,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorInfoWidget(snapshot.error!);
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingOverlay();
            }
            settingsMap ??= viewModel.settings.videos;
            return _buildPage();
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
              Navigate.pop(context, settingsMap != null);
            },
            child: Text("Speichern"),
          ),
        )
      ],
    );
  }

  SettingsTile _buildSwitch(String title, String key, IconData icon) =>
      SettingsTile.switchTile(
        onToggle: (value) async => setState(() => settingsMap![key] = value),
        initialValue: settingsMap![key],
        leading: Icon(icon),
        title: Text(title),
      );

  Widget _buildPage() => SettingsList(
        sections: [
          SettingsSection(
            title: Text('Wiedergabe'),
            tiles: <SettingsTile>[
              _buildSwitch("Automatisch", "autoPlay", Icons.play_arrow),
              _buildSwitch("Wiederholen", "looping", Icons.repeat),
            ],
          ),
          SettingsSection(
            title: Text('Steuerung'),
            tiles: <SettingsTile>[
              _buildSwitch("Sofort zeigen", "showControlsOnInitialize",
                  Icons.call_to_action_outlined),
            ],
          ),
        ],
      );
}
