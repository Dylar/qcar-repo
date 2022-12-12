import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/widgets/deco.dart';

void showSnackBar(BuildContext context, String text, {int duration = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            gradient: qcarGradient),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: BaseColors.primary),
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0.0),
    ),
  );
}
