import 'package:flutter/material.dart';
import 'package:qcar_customer/ui/app_theme.dart';

class RoundedWidget extends StatelessWidget {
  const RoundedWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: BaseColors.babyBlue),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }
}
