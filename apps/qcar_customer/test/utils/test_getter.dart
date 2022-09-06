import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/home/home_vm.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_vm.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_vm.dart';

HomeViewModel getHomeViewModel() => find
    .byType(HomePage)
    .evaluate()
    .map((e) => e.widget)
    .whereType<HomePage>()
    .first
    .viewModel;

IntroViewModel getIntroViewModel() => find
    .byType(IntroPage)
    .evaluate()
    .map((e) => e.widget)
    .whereType<IntroPage>()
    .first
    .viewModel;

QRViewModel getQRViewModel() => find
    .byType(QrScanPage)
    .evaluate()
    .map((e) => e.widget)
    .whereType<QrScanPage>()
    .first
    .viewModel;
