import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:carmanual/ui/widgets/scroll_list_view.dart';
import 'package:flutter/material.dart';

class VideoSettingsPage extends StatefulWidget {
  static const String routeName = "/videoSettingsPage";

  VideoSettingsPage(this.settings);

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  final SettingsDataSource settings;

  @override
  State<VideoSettingsPage> createState() => _VideoSettingsPageState();
}

class _VideoSettingsPageState extends State<VideoSettingsPage> {
  Settings? _settings;
  Map<String, bool>? settingsMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideoSettings")),
      body: FutureBuilder<Settings>(
          future: widget.settings.getSettings(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorInfoWidget(snapshot.error.toString());
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingOverlay();
            }
            _settings = snapshot.data;
            settingsMap ??= _settings?.videos;
            return ScrollListView<MapEntry<String, bool>>(
              items: settingsMap?.entries.toList(),
              buildItemWidget: (_, item) => wrapWidget(
                item.key,
                _VideoSettingsInfoText("${item.key}", item.value),
              ),
            );
          }),
      persistentFooterButtons: [
        Container(
          height: 48,
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () async {
              _settings!.videos = settingsMap!;
              await widget.settings.saveSettings(_settings!);
              Navigate.pop(context, true);
            },
            child: Text("Speichern"),
          ),
        )
      ],
    );
  }

  Widget wrapWidget(String key, Widget child) => GestureDetector(
        onTap: () =>
            setState(() => settingsMap![key] = !(settingsMap![key] ?? false)),
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(4.0),
          child: child,
        ),
      );
}

class _VideoSettingsInfoText extends StatelessWidget {
  _VideoSettingsInfoText(this.title, this.enabled);

  final String title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: enabled ? BaseColors.green : BaseColors.red,
          border: Border.all(color: BaseColors.accent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(title)),
          Flexible(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(enabled ? "True" : "False"))),
        ],
      ),
    );
  }
}
