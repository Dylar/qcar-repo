import 'package:carmanual/core/constants/debug.dart';
import 'package:flutter/material.dart';

class SkipDebugButton extends StatelessWidget {
  const SkipDebugButton(this.onTap);

  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () => onTap(DEBUG_CARINFO),
        child: Text("Debug: Skip"),
      ),
    );
  }
}
