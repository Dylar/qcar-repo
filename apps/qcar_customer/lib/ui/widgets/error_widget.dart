import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';

import '../../core/tracking.dart';

class ErrorInfoWidget extends StatelessWidget {
  const ErrorInfoWidget(this.error);

  final Object error;

  @override
  Widget build(BuildContext context) {
    Logger.logE("ErrorInfoWidget: $error", printTrace: true);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: BaseColors.red),
          Text(
            error.toString(),
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: BaseColors.red),
          ),
        ],
      ),
    );
  }
}
