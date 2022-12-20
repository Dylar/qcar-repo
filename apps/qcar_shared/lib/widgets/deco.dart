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
  double textScaling = 1.0,
}) {
  return GradientText(
    text,
    style: style,
    gradient: qcarGradient,
    textScaling: textScaling,
  );
}

InkWell inkTap({
  required void Function()? onTap,
  required Widget child,
}) =>
    InkWell(
        highlightColor: BaseColors.zergPurple.withOpacity(0.4),
        splashColor: BaseColors.babyBlue.withOpacity(0.5),
        onTap: onTap,
        child: child);
