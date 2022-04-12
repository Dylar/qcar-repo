import 'package:flutter/material.dart';

class BaseColors {
  static const Color primary = Color.fromRGBO(24, 22, 22, 1);
  static const Color accent = Color.fromRGBO(34, 32, 32, 1);

  static const Color green = Color.fromRGBO(121, 206, 27, 1);
  static const Color yellow = Color.fromRGBO(252, 229, 49, 1);
  static const Color red = Color.fromRGBO(222, 30, 30, 1);
  static const Color blue = Color.fromRGBO(30, 30, 222, 1);
  static const Color babyBlue = Color.fromRGBO(0, 255, 255, 1.0);
  static const Color zergPurple = Color.fromRGBO(254, 46, 247, 1);

  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color darkGrey = Color.fromRGBO(0, 0, 0, 0.4);
  static const Color grey = Color.fromRGBO(196, 196, 196, 0.4);
  static const Color lightGrey = Color.fromRGBO(196, 196, 196, 1);
  static const Color veryLightGrey = Color.fromRGBO(245, 245, 245, 1);
}

const TextTheme textSizes = TextTheme(
    bodyText1: TextStyle(fontSize: 14.0),
    bodyText2: TextStyle(fontSize: 12.0),
    subtitle1: TextStyle(fontSize: 16.0),
    subtitle2: TextStyle(fontSize: 16.0, letterSpacing: 0.25),
    caption: TextStyle(fontSize: 12.0),
    button: TextStyle(fontSize: 14, letterSpacing: 1.25),
    headline6: TextStyle(letterSpacing: 0.25, fontSize: 20.0));

const TextTheme textColors = TextTheme(
    bodyText1: TextStyle(color: BaseColors.veryLightGrey),
    bodyText2: TextStyle(color: BaseColors.veryLightGrey),
    subtitle1: TextStyle(color: BaseColors.veryLightGrey),
    subtitle2: TextStyle(color: BaseColors.veryLightGrey),
    caption: TextStyle(color: BaseColors.veryLightGrey));

const TextTheme primaryTextColors = TextTheme(
    bodyText2: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
    subtitle1: TextStyle(color: BaseColors.veryLightGrey),
    subtitle2: TextStyle(color: BaseColors.veryLightGrey),
    headline6: TextStyle(color: BaseColors.veryLightGrey));

const TextTheme accentTextColors = TextTheme(
    subtitle1: TextStyle(color: BaseColors.veryLightGrey),
    subtitle2: TextStyle(color: BaseColors.veryLightGrey));

final ThemeData appTheme = ThemeData(
  fontFamily: 'RobotoCondensed',
  brightness: Brightness.dark,
  primaryColor: BaseColors.primary,
  // ignore: deprecated_member_use
  accentColor: BaseColors.accent,
  canvasColor: BaseColors.primary,
  backgroundColor: BaseColors.primary,
  primaryTextTheme: textSizes.merge(primaryTextColors),
  // ignore: deprecated_member_use
  accentTextTheme: textSizes.merge(accentTextColors),
  textTheme: textSizes.merge(textColors),
  appBarTheme: AppBarTheme(
    color: BaseColors.primary,
    iconTheme: IconThemeData(color: BaseColors.lightGrey),
    titleTextStyle: textSizes.merge(primaryTextColors).headline6,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: BaseColors.lightGrey,
    unselectedLabelColor: BaseColors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: BaseColors.lightGrey, width: 2.0),
    ),
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: BaseColors.primary),
  unselectedWidgetColor: BaseColors.grey,
  cardTheme: CardTheme(color: BaseColors.accent),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: BaseColors.primary),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: InputBorder.none,
  ),
);
