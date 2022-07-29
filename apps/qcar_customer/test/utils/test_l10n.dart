import 'dart:convert';
import 'dart:io';

Future<TestAppLocalization> getTestL10n({String local = "de"}) async {
  final file = File('lib/l10n/app_$local.arb').readAsStringSync();
  return TestAppLocalization(jsonDecode(file));
}

class TestAppLocalization {
  const TestAppLocalization(this._values);

  final Map<String, dynamic> _values;

  //------BUTTONS
  String get send => _values["send"];
  String get cancel => _values["cancel"];

  //------INTRO
  String get introPageMessage => _values["introPageMessage"];
  String get introPageMessageError => _values["introPageMessageError"];
  String get introPageMessageScanning => _values["introPageMessageScanning"];

  //------SEARCH
  String get searchStartText => _values["searchStartText"];
  String get searchEmptyText => _values["searchEmptyText"];

  //--------FEEDBACK
  String get feedbackThanks => _values["feedbackThanks"];
}
