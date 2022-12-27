import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/ui/screens/login/login_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class LoginPage extends View<LoginViewModel> {
  static const String routeName = "/login";

  static RoutingSpec pushIt() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
      );

  static RoutingSpec onLogout() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.replaceAllWith,
        transitionType: TransitionType.leftRight,
      );

  LoginPage(
    LoginViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<LoginPage> createState() => _LoginPageState(viewModel);
}

class _LoginPageState extends ViewState<LoginPage, LoginViewModel> {
  _LoginPageState(LoginViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar(l10n.loginTitle),
      body: buildLoginPage(context, l10n),
    );
  }

  Widget buildLoginPage(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: qcarGradientBox,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RoundedWidget(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(l10n.loginText),
                ),
              ),
            ),
            DropdownButton<SellerInfo>(
              dropdownColor: BaseColors.darkGrey,
              items: _buildDropdownItems(),
              hint: Text(l10n.loginSelectUser),
              onChanged: (value) => viewModel.userSelected(value!),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<SellerInfo>> _buildDropdownItems() {
    return viewModel.sellers
        .map((e) => DropdownMenuItem<SellerInfo>(value: e, child: Text(e.name)))
        .toList();
  }
}
