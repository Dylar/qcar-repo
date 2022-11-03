import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCameraView extends StatefulWidget {
  const QRCameraView(this.onScan);

  final void Function(Barcode) onScan;

  @override
  State<StatefulWidget> createState() => _QRCameraViewState();
}

class _QRCameraViewState extends State<QRCameraView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller?.resumeCamera(),
      child: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() => widget.onScan(scanData));
      }
    });
  }
}
