import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/ui/screens/dir/dir_page.dart';
import 'package:carmanual/ui/screens/overview/car_info_list_item.dart';
import 'package:carmanual/ui/viewmodels/car_overview_vm.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:carmanual/ui/widgets/scroll_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarOverviewPage extends View<CarOverViewModel> {
  static const String routeName = "/carOverviewPage";

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  CarOverviewPage.model(CarOverViewModel viewModel) : super.model(viewModel);

  @override
  State<CarOverviewPage> createState() => _CarOverviewPageState(viewModel);
}

class _CarOverviewPageState
    extends ViewState<CarOverviewPage, CarOverViewModel> {
  _CarOverviewPageState(CarOverViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.carOverViewPageTitle)),
      body: _buildBody(context, l10n),
      bottomNavigationBar: AppNavigation(CarOverviewPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<List<CarInfo>>(
        stream: viewModel.watchCars(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorInfoWidget(snapshot.error.toString());
          }

          return ScrollListView<CarInfo>(
            items: snapshot.data,
            buildItemWidget: buildItemWidget,
          );
        });
  }

  Widget buildItemWidget(int index, CarInfo item) => GestureDetector(
        child: CarInfoListItem(item),
        onTap: () => Navigate.to(
          context,
          DirPage.pushIt(item),
        ),
      );
}
