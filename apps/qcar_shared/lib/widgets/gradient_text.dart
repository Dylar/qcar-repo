import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
    this.textScaling = 1.0,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  final double textScaling;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Center(
        child: Text(
          text,
          style: style,
          textScaleFactor: textScaling,
        ),
      ),
    );
  }
}
