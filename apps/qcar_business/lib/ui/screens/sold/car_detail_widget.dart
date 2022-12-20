import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/ui/widgets/list/cars_list_item.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class CarDetailWidget extends StatelessWidget {
  CarDetailWidget(this.car);

  final CarInfo car;

  @override
  Widget build(BuildContext context) {
    return RoundedWidget(child: CarInfoListItem(car));
  }
}
