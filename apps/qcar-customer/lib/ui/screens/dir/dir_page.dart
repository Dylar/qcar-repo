import 'package:carmanual/core/navigation/app_bar.dart';
import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/ui/screens/dir/dir_list_item.dart';
import 'package:carmanual/ui/widgets/scroll_list_view.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/dir_vm.dart';

class DirPage extends View<DirViewModel> {
  static const String routeName = "/dirPage";
  static const String ARG_CAR = "car";

  static AppRouteSpec pushIt(CarInfo carInfo) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_CAR: carInfo},
      );

  DirPage.model(DirViewModel viewModel) : super.model(viewModel);

  @override
  State<DirPage> createState() => _DirPageState(viewModel);
}

class _DirPageState extends ViewState<DirPage, DirViewModel> {
  _DirPageState(DirViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(viewModel.title),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(DirPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScrollListView<CategoryInfo>(
      items: viewModel.getDirs(),
      buildItemWidget: buildItemWidget,
    );
  }

  Widget buildItemWidget(int index, CategoryInfo item) {
    return GestureDetector(
      child: DirListItem(item),
      onTap: () => viewModel.selectDir(item),
    );
  }
}
