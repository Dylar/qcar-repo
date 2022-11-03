import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/core/misc/constants/asset_paths.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/navigation/app_navigation.dart';
import 'package:qcar_business/ui/navigation/navi.dart';
import 'package:qcar_business/ui/screens/home/home_vm.dart';
import 'package:qcar_business/ui/widgets/deco.dart';
import 'package:qcar_business/ui/widgets/info_widget.dart';
import 'package:qcar_business/ui/widgets/rounded_widget.dart';
import 'package:qcar_business/ui/widgets/video_widget.dart';

class HomePage extends View<HomeViewModel> {
  static const String routeName = "/home";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  static AppRouteSpec poopToRoot() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popUntilRoot,
      );

  static AppRouteSpec replaceWith() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.replaceWith,
      );

  HomePage(
    HomeViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<HomePage> createState() => _HomePageState(viewModel);
}

class _HomePageState extends ViewState<HomePage, HomeViewModel> {
  _HomePageState(HomeViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context)!.homoPageTitle;
    return Scaffold(
      appBar: _buildAppBar(title),
      body: buildHomePage(context),
      bottomNavigationBar: AppNavigation(viewModel, HomePage.routeName),
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

  Widget buildHomePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: qcarGradientBox,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: RoundedWidget(child: VideoWidget(viewModel: viewModel)),
            ),
            // Spacer(flex: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InfoWidget(
                  l10n.homoPageSubGreetings + "\n\n" + l10n.homoPageMessage),
            ),
            // Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}