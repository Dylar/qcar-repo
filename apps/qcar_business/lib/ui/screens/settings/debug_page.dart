import 'package:flutter/material.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:settings_ui/settings_ui.dart';

class DebugPage extends StatefulWidget {
  static const String routeName = "/debugPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DEBUG")),
      body: _buildPage(),
      persistentFooterButtons: [],
    );
  }

  Widget _buildPage() => SettingsList(
        sections: [
          SettingsSection(
            title: Text('Menu'),
            tiles: <SettingsTile>[
              _buildButton("Env:", "${EnvironmentConfig.ENV}"),
              _buildButton("Domain:", "${EnvironmentConfig.domain}"),
              _buildButton("Host:", "${EnvironmentConfig.host}"),
              _buildButton("Backend url:", "${EnvironmentConfig.backendUrl}"),
            ],
          ),
        ],
      );

  SettingsTile _buildButton(String title, String value) =>
      SettingsTile.navigation(
        title: Text(title),
        value: Text(value),
      );
}
