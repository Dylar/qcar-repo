import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';

class RoundedWidget extends StatelessWidget {
  const RoundedWidget({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: color ?? BaseColors.babyBlue),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }
}
