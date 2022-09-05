enum QrScanState { NEW, OLD, DAFUQ, WAITING, SCANNING }

mixin ScanFun {
  void scanIt(String text) {}
}
