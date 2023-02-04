import 'dart:convert';
import 'dart:io';

Future<TestAppLocalization> getTestL10n({String local = "de"}) async {
  final file = File('lib/l10n/app_$local.arb').readAsStringSync();
  return TestAppLocalization(jsonDecode(file));
}

class TestAppLocalization {
  const TestAppLocalization(this._values);

  final Map<String, dynamic> _values;

  // TODO make this correct

  //------GENERIC
  String get yes => _values["yes"];
  String get no => _values["no"];
  String get ok => _values["ok"];
  String get cancel => _values["cancel"];

  //------DIALOG
  String get errorTitle => _values["errorTitle"];
  String get notSavedTitle => _values["notSavedTitle"];
  String get notSavedMessage => _values["notSavedMessage"];
  String get decideTrackingTitle => _values["decideTrackingTitle"];
  String get decideTrackingMessage => _values["decideTrackingMessage"];

  //------LOGIN
  String noDealerFound(String name) =>
      _values["noDealerFound"].toString().replaceFirst("{dealerName}", name);
}
