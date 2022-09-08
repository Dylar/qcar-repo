import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';

void main() {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async => runApp(App()));
}
