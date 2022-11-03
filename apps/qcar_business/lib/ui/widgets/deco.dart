import 'package:flutter/material.dart';
import 'package:qcar_business/ui/app_theme.dart';
import 'package:qcar_business/ui/widgets/gradient_text.dart';

BoxDecoration get qcarGradientBox => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          BaseColors.primary,
          BaseColors.accent,
        ],
        tileMode: TileMode.clamp,
      ),
    );

final qcarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      BaseColors.babyBlue,
      BaseColors.zergPurple,
    ]);

GradientText qcarGradientText(
  BuildContext context,
  String text, {
  TextStyle? style,
}) {
  return GradientText(
    text,
    style: style,
    gradient: qcarGradient,
  );
}
