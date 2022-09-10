import 'dart:convert';
import 'dart:io';

Future<TestAppLocalization> getTestL10n({String local = "de"}) async {
  final file = File('lib/l10n/app_$local.arb').readAsStringSync();
  return TestAppLocalization(jsonDecode(file));
}

class TestAppLocalization {
  const TestAppLocalization(this._values);

  final Map<String, dynamic> _values;

  //------GENERIC
  String get yes => _values["yes"];
  String get no => _values["no"];
  String get ok => _values["ok"];
  String get cancel => _values["cancel"];

  //------DIALOG
  String get errorTitle => _values["errorTitle"];
  String get notSavedTitle => _values["notSavedTitle"];
  String get notSavedMessage => _values["notSavedMessage"];

  //------BUTTONS
  String get send => _values["send"];
  String get save => _values["save"];

  //------SCAN
  String get oldCarScanned => _values["oldCarScanned"];

  //------INTRO
  String get introPageMessage => _values["introPageMessage"];
  String get scanError => _values["scanError"];
  String get introPageMessageScanning => _values["introPageMessageScanning"];

  //------SEARCH
  String get searchStartText => _values["searchStartText"];
  String get searchEmptyText => _values["searchEmptyText"];

  //------FEEDBACK
  String get feedbackThanks => _values["feedbackThanks"];
  String get feedbackError => _values["feedbackError"];

  //------SETTINGS
  String get settingsPageTitle => _values["settingsPageTitle"];
  String get debugMenu => _values["debugMenu"];
  String get videoMenu => _values["videoMenu"];
  String get aboutDialog => _values["aboutDialog"];
  String get autoPlay => _values["autoPlay"];
}
