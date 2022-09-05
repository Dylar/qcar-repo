import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qcar_customer/core/helper/common.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/service/auth_service.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';

enum LandingState { STARTING, SIGN_IN, SCAN_QR, GO_HOME }

abstract class LandingViewModel extends ViewModel {
  ValueNotifier<Tuple<double, double>>? progressValue;
}

class LandingVM extends LandingViewModel {
  LandingVM(
    this.authService,
    this.infoService,
  ) {
    progressValue = infoService.progressValue;
  }

  final AuthenticationService authService;
  final InfoService infoService;

  @override
  void init() {
    super.init();
    _initApp().then(_handleState);
  }

  Future<LandingState> _initApp() async {
    final start = DateTime.now();
    final LandingState state;
    final signedIn = await authService.signInAnon();
    if (!signedIn) {
      state = LandingState.SIGN_IN;
    } else {
      final hasCars = await infoService.hasCars();
      if (hasCars) {
        await infoService.refreshCarInfos();
        state = LandingState.GO_HOME;
      } else {
        state = LandingState.SCAN_QR;
      }
    }
    await waitDiff(start);
    return state;
  }

  Future _handleState(LandingState state) async {
    switch (state) {
      case LandingState.SIGN_IN:
      // navigateTo(HomePage.poopToRoot());
      // break;
      case LandingState.SCAN_QR:
        navigateTo(IntroPage.popAndPush());
        break;
      case LandingState.GO_HOME:
        navigateTo(HomePage.popAndPush());
        break;
      default:
        notifyListeners();
        break;
    }
  }

  Future waitDiff(DateTime start) async {
    final diff = DateTime.now().difference(start).inMilliseconds;
    final rest = MILLI_PER_SEC * 3 - diff;
    if ((rest > 0)) {
      await Future.delayed(Duration(milliseconds: rest));
    }
  }
}
