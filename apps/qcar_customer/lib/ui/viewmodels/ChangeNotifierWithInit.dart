import 'package:flutter/material.dart';

abstract class ChangeNotifierWithInit extends ChangeNotifier {
  bool initialized = false;

  @mustCallSuper
  void init() {
    initialized = true;
  }
}
