import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/ui/screens/cars/car_info_list_item.dart';
import 'package:qcar_customer/ui/screens/categories/categories_page.dart';
import 'package:qcar_customer/ui/viewmodels/car_overview_vm.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/scroll_list_view.dart';

class CarsPage extends View<CarsViewModel> {
  static const String routeName = "/carsPage";

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  CarsPage.model(CarsViewModel viewModel) : super.model(viewModel);

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
      bottomNavigationBar: AppNavigation(CarsPage.routeName),
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

  Widget buildItemWidget(int index, CarInfo item) => InkWell(
        highlightColor: BaseColors.zergPurple.withOpacity(0.4),
        splashColor: BaseColors.babyBlue.withOpacity(0.5),
        child: CarInfoListItem(item),
        onTap: () => Navigate.to(context, CategoriesPage.pushIt(item)),
      );
}
