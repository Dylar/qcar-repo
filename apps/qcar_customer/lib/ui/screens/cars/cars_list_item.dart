import 'package:flutter/material.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/ui/widgets/pic_widget.dart';

import '../../../core/constants/debug.dart';

class CarInfoListItem extends StatelessWidget {
  const CarInfoListItem(this.carInfo);

  final CarInfo carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: PicWidget(DEBUG_PIC_URL),
          ),
          Spacer(flex: 5),
          Expanded(
            flex: 95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marke: ${carInfo.brand}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text('Model: ${carInfo.model}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
