import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/misc/constants/asset_paths.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/debug_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/loading_overlay.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends View<SettingsViewModel> {
  static const String routeName = "/settingsPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  SettingsPage.model(SettingsViewModel viewModel) : super.model(viewModel);

  @override
  State<SettingsPage> createState() => _SettingsPageState(viewModel);
}

class _SettingsPageState extends ViewState<SettingsPage, SettingsViewModel> {
  _SettingsPageState(SettingsViewModel viewModel) : super(viewModel);
  bool showDebug = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsPageTitle),
      ),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(viewModel, SettingsPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<void>(
        future: viewModel.isInitialized,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorInfoWidget(snapshot.error!);
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingOverlay();
          }
          return _buildPage();
        });
  }

  SettingsTile _buildButton(
          String title, IconData icon, Function(BuildContext) onTap) =>
      SettingsTile.navigation(
        leading: Icon(icon),
        title: Text(title),
        onPressed: onTap,
      );

  Widget _buildPage() => SettingsList(
        sections: [
          SettingsSection(
            title: Text('Menu'),
            tiles: <SettingsTile>[
              if (EnvironmentConfig.isDev || showDebug)
                _buildButton(
                  "DEBUG",
                  Icons.settings_cell_rounded,
                  (context) => Navigate.to(context, DebugPage.pushIt()),
                ),
              _buildButton(
                "Video",
                Icons.call_to_action_outlined,
                (context) =>
                    Navigate.to(context, VideoSettingsPage.pushIt(viewModel)),
              ),
              _buildButton(
                "Informationen",
                Icons.info,
                (context) => showAboutDialog(
                  context: context,
                  applicationIcon: SizedBox.square(
                    child: Image.asset(launcherIcon),
                    dimension: 48,
                  ),
                  applicationName: EnvironmentConfig.APP_NAME,
                  applicationVersion: EnvironmentConfig.VERSION,
                ),
              ),
            ],
          ),
        ],
      );
}
