import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class CarListItem extends StatelessWidget {
  const CarListItem(this.carInfo);

  final CarInfo carInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RoundedWidget(
                child:
                    PicWidget(carInfo.picUrl)), //PicWidget(carInfo.imagePath)),
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
      ),
    );
  }
}
