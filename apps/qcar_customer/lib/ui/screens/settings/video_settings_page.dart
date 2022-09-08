import 'package:flutter/material.dart';
import 'package:qcar_customer/ui/app_theme.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/settings/settings_vm.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/loading_overlay.dart';
import 'package:qcar_customer/ui/widgets/scroll_list_view.dart';

class VideoSettingsPage extends View<SettingsViewModel> {
  static const String routeName = "/videoSettingsPage";

  VideoSettingsPage.model(SettingsViewModel viewModel) : super.model(viewModel);

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

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

  Widget wrapWidget(String key, Widget child) => InkWell(
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
