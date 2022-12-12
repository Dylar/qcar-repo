import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/screens/cars/cars_list_item.dart';
import 'package:qcar_customer/ui/screens/cars/cars_vm.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/error_widget.dart';
import 'package:qcar_shared/widgets/scroll_list_view.dart';

class CarsPage extends View<CarsViewModel> {
  static const String routeName = "/carsPage";

  static RoutingSpec popAndPush() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.popAndPushTo,
      );

  static RoutingSpec pushIt() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
      );

  CarsPage(CarsViewModel viewModel) : super.model(viewModel);

  @override
  State<CarsPage> createState() => _CarsPageState(viewModel);
}

class _CarsPageState extends ViewState<CarsPage, CarsViewModel> {
  _CarsPageState(CarsViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.carOverViewPageTitle)),
      body: _buildBody(context, l10n),
      bottomNavigationBar: AppNavigation(viewModel, CarsPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<List<CarInfo>>(
        stream: viewModel.watchCars(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorInfoWidget(snapshot.error!);
          }

          return ScrollListView<CarInfo>(
            items: snapshot.data,
            buildItemWidget: buildItemWidget,
          );
        });
  }

  Widget buildItemWidget(int index, CarInfo item) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          highlightColor: BaseColors.zergPurple.withOpacity(0.4),
          splashColor: BaseColors.babyBlue.withOpacity(0.5),
          child: CarInfoListItem(item),
          onTap: () => Navigate.to(context, CategoriesPage.pushIt(item)),
        ),
      );
}
