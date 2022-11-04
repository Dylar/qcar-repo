import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/widgets/gradient_text.dart';

BoxDecoration get qcarGradientBox => const BoxDecoration(
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

const qcarGradient = LinearGradient(
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
