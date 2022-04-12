import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/debug.dart';

class CarInfoListItem extends StatelessWidget {
  const CarInfoListItem(this.carInfo);

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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CarInfoPic(DEBUG_PIC_URL),
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
      ),
    );
  }
}

class CarInfoPic extends StatelessWidget {
  const CarInfoPic(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      child: Image.network(
        url,
        loadingBuilder: loadingWidget,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) =>
            ErrorInfoWidget("Error"),
      ),
    );
  }

  Widget loadingWidget(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}
