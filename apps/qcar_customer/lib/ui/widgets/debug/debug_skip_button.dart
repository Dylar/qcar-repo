import 'package:flutter/material.dart';
import 'package:qcar_customer/core/constants/debug.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SkipDebugButton extends StatelessWidget {
  const SkipDebugButton(this.onTap);

  final void Function(Barcode) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () => onTap(Barcode(DEBUG_CARINFO, BarcodeFormat.aztec, [])),
        child: Text("Debug: Skip"),
      ),
    );
  }
}
