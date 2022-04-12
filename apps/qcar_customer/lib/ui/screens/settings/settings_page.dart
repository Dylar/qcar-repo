import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/debug_page.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';
import 'package:qcar_customer/ui/snackbars/snackbars.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = "/settingsPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showDebug = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsPageTitle),
      ),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(SettingsPage.routeName),
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
            child: GestureDetector(
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
