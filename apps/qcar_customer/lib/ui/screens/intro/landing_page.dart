import 'package:flutter/material.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/ui/screens/intro/landing_vm.dart';
import 'package:qcar_customer/ui/screens/intro/loading_page.dart';

class LandingPage extends View<LandingViewModel> {
  static const String routeName = "/";

  LandingPage.model(LandingViewModel viewModel, {Key? key})
      : super.model(viewModel, key: key);

  @override
  State<LandingPage> createState() => _LandingPageState(viewModel);
}

class _LandingPageState extends ViewState<LandingPage, LandingViewModel> {
  _LandingPageState(LandingViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LoadingStartPage(progressValue: viewModel.progressValue),
    );
  }
}
