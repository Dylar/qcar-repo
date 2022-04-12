import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/navigation/navi.dart';

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
    // final appClient = Services.of(context)!.appClient;
    return Scaffold(
      appBar: AppBar(title: Text("DEBUG")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          wrapWidget(_DebugInfoText("Env:", "${EnvironmentConfig.ENV}")),
          wrapWidget(_DebugInfoText("Domain:", "${EnvironmentConfig.domain}")),
          wrapWidget(_DebugInfoText("Host:", "${EnvironmentConfig.host}")),
          wrapWidget(_DebugInfoText("Port:", "${EnvironmentConfig.port}")),
        ],
      ),
      persistentFooterButtons: [
        // _DebugButton(
        //   "Load files",
        //   () => appClient
        //       .loadCarInfo("Toyota", "Corolla")
        //       .then((value) => setState(() => dir = value)),
        // ),
      ],
    );
  }

  Widget wrapWidget(Widget child) => Flexible(
      child: Padding(padding: const EdgeInsets.all(4.0), child: child));

  // Column _buildDir(DirData dir) {
  //   return Column(children: [
  //     _DebugInfoText("Dir:", dir.path),
  //     if (dir.files.isNotEmpty)
  //       ...dir.files.map<Widget>(
  //           (element) => wrapWidget(_DebugInfoText("File:", "${element}"))),
  //     if (dir.dirs.isNotEmpty)
  //       ...dir.dirs.map<Widget>((element) => _buildDir(element))
  //   ]);
  // }
}

class _DebugInfoText extends StatelessWidget {
  _DebugInfoText(this.title, this.text);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: BaseColors.veryLightGrey,
          border: Border.all(color: BaseColors.accent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(title)),
          Flexible(
              child: Align(alignment: Alignment.centerLeft, child: Text(text))),
        ],
      ),
    );
  }
}

// class _DebugButton extends StatelessWidget {
//   _DebugButton(this.name, this.callback);
//
//   final String name;
//   final VoidCallback callback;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       padding: const EdgeInsets.all(4.0),
//       child: ElevatedButton(
//         onPressed: callback,
//         child: Text(name),
//       ),
//     );
//   }
// }
