import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/utils/logger.dart';

class ErrorInfoWidget extends StatelessWidget {
  const ErrorInfoWidget(this.error, {super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    Logger.logE("ErrorInfoWidget: $error", printTrace: true);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: BaseColors.red),
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
