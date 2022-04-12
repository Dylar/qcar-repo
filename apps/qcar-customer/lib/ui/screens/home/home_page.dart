import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/ui/viewmodels/home_vm.dart';
import 'package:carmanual/ui/widgets/info_widget.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends View<HomeViewModel> {
  static const String routeName = "/home";

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
      appBar: AppBar(title: Text(title)),
      body: HomeVideoPage.model(viewModel),
      bottomNavigationBar: AppNavigation(HomePage.routeName),
    );
  }
}

class HomeVideoPage extends View<HomeViewModel> {
  HomeVideoPage.model(HomeViewModel viewModel) : super.model(viewModel);

  @override
  State<HomeVideoPage> createState() => _HomeVideoPageState(viewModel);
}

class _HomeVideoPageState extends ViewState<HomeVideoPage, HomeViewModel> {
  _HomeVideoPageState(HomeViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     image: DecorationImage(
          //       fit: BoxFit.fitWidth,
          //       image: AssetImage(homePageCarLogoImagePath),
          //     ),
          //   ),
          // ),
          StreamBuilder<Settings>(
            stream: viewModel.watchSettings(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || viewModel.introVideo == null) {
                return VideoDownload();
              }
              return VideoWidget(
                url: viewModel.introVideo!.vidUrl,
                settings: snapshot.data!,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InfoWidget(
                l10n.homoPageSubGreetings + "\n\n" + l10n.homoPageMessage),
          ),
        ],
      ),
    );
  }
}
