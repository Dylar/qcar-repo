import 'package:carmanual/core/app_theme.dart';
import 'package:flutter/material.dart';

import '../../core/tracking.dart';

class ErrorInfoWidget extends StatelessWidget {
  const ErrorInfoWidget(this.error);

  final String error;

  @override
  Widget build(BuildContext context) {
    Logger.logE("ErrorInfoWidget: $error");
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
            error,
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
