import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/ui/navigation/app_drawer.dart';
import 'package:qcar_business/ui/screens/form/form_cars_page.dart';
import 'package:qcar_business/ui/screens/home/home_vm.dart';
import 'package:qcar_business/ui/screens/sale/sale_page.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_business/ui/widgets/list/sale_list_item.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';
import 'package:qcar_shared/widgets/scroll_list_view.dart';

class HomePage extends View<HomeViewModel> {
  static const String routeName = "/home";

  static RoutingSpec popAndPush() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.popAndPushTo,
        transitionTime: const Duration(milliseconds: 300),
        transitionType: TransitionType.fading,
      );

  static RoutingSpec onSaleSaving() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.replaceAllWith,
        transitionType: TransitionType.leftRight,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar(l10n.homoPageTitle),
      drawer: AppDrawer(),
      body: buildHomePage(context, l10n),
      floatingActionButton: FloatingActionButton(
        foregroundColor: BaseColors.zergPurple,
        backgroundColor: BaseColors.babyBlue,
        child: Icon(Icons.add_shopping_cart),
        onPressed: () => Navigate.to(context, FormCarsPage.pushIt()),
      ),
    );
  }

  Widget buildHomePage(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: qcarGradientBox,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          RoundedWidget(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text("Das ist die Business-App"),
            ),
          ),
          ScrollListView<SaleInfo>(
            emptyWidget: RoundedWidget(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Text(l10n.homoPageEmptySales),
              ),
            ),
            items: viewModel.saleInfos,
            buildItemWidget: (int index, item) {
              return SaleListItem(
                item,
                onTap: () => Navigate.to(context, SalePage.pushIt(item)),
              );
            },
          ),
        ],
      ),
    );
  }
}
