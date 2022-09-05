import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/navigation/app_bar.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/ui/screens/cars/categories_list_item.dart';
import 'package:qcar_customer/ui/screens/cars/categories_vm.dart';
import 'package:qcar_customer/ui/widgets/scroll_list_view.dart';

class CategoriesPage extends View<CategoriesViewModel> {
  static const String routeName = "/categoriesPage";
  static const String ARG_CAR = "car";

  static AppRouteSpec pushIt(CarInfo carInfo) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_CAR: carInfo},
      );

  CategoriesPage.model(CategoriesViewModel viewModel) : super.model(viewModel);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState(viewModel);
}

class _CategoriesPageState
    extends ViewState<CategoriesPage, CategoriesViewModel> {
  _CategoriesPageState(CategoriesViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(viewModel.title, viewModel),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(viewModel, CategoriesPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScrollListView<CategoryInfo>(
      items: viewModel.categories,
      buildItemWidget: buildItemWidget,
    );
  }

  Widget buildItemWidget(int index, CategoryInfo item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        highlightColor: BaseColors.zergPurple.withOpacity(0.4),
        splashColor: BaseColors.babyBlue.withOpacity(0.5),
        child: CategoryListItem(item),
        onTap: () => viewModel.selectCategory(item),
      ),
    );
  }
}
