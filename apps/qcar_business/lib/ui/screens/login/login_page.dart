import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/core/misc/constants/asset_paths.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/ui/screens/login/login_vm.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class LoginPage extends View<LoginViewModel> {
  static const String routeName = "/login";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
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
    // final title = AppLocalizations.of(context)!.homoPageTitle;
    final title = "Login";
    return Scaffold(
      appBar: _buildAppBar(title),
      body: buildLoginPage(context),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          qcarGradientText(
            context,
            EnvironmentConfig.APP_NAME,
            style: Theme.of(context).textTheme.headline6!,
          ),
          SizedBox(
              height: 48,
              width: 48,
              //TODO load from car path
              child: Image.asset(homePageCarLogoImagePath)),
        ],
      ),
    );
  }

  Widget buildLoginPage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: qcarGradientBox,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: RoundedWidget(
                  child: Text(
                      "Das ist die Business-App.\nBitte melden Sie sich an.")),
            ),
            DropdownButton<SellerInfo>(
              items: _buildDropdownItems(),
              hint: Text("Bitte wählen Sie einen Benutzer"),
              value: null,
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
