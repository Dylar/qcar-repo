import 'package:flutter/material.dart';

void showNothingToSeeSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Kommt noch'),
      duration: Duration(seconds: 1),
    ),
  );
}

void showAlreadyHereSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Du bist auf dieser Seite'),
      duration: Duration(seconds: 1),
    ),
  );
}

void showSettingsSavedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Gespeichert'),
      duration: Duration(seconds: 1),
    ),
  );
}
