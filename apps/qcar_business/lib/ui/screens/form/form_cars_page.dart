import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/ui/screens/form/form_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_business/ui/widgets/list/cars_list_item.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/scroll_list_view.dart';

class FormCarsPage extends View<FormViewModel> {
  static const String routeName = "/formCars";

  static RoutingSpec pushIt() => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
        transitionTime: const Duration(milliseconds: 200),
        transitionType: TransitionType.rightLeft,
      );

  FormCarsPage(
    FormViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<FormCarsPage> createState() => _FormCarPageState(viewModel);
}

class _FormCarPageState extends ViewState<FormCarsPage, FormViewModel> {
  _FormCarPageState(FormViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar(l10n.formCarTitle),
      body: buildFormPage(context),
    );
  }

  Widget buildFormPage(BuildContext context) {
    return Container(
      decoration: qcarGradientBox,
      alignment: Alignment.topCenter,
      child: ScrollListView<CarInfo>(
        items: viewModel.cars,
        buildItemWidget: (_, car) => inkTap(
          onTap: () => viewModel.selectCar(car),
          child: CarListItem(car),
        ),
      ),
    );
  }
}
