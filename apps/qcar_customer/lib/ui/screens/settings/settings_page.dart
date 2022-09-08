import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';
import 'package:qcar_customer/ui/screens/debug_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';

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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          if (EnvironmentConfig.isDev || showDebug)
            Flexible(child: SettingsButton("Debug", DebugPage.pushIt())),
          Flexible(
            child: InkWell(
              onLongPress: () => setState(() => showDebug = true),
              child: SettingsButton(
                "Video Einstellungen",
                VideoSettingsPage.pushIt(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  SettingsButton(this.name, this.route);

  final AppRouteSpec route;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigate.to(context, route);
          if (result == true) {
            showSettingsSavedSnackBar(context);
          }
        },
        child: Text(name),
      ),
    );
  }
}
