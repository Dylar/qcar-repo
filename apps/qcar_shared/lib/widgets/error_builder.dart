import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/utils/logger.dart';

Widget buildImageError(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  Logger.logE(StackTrace.current.toString());
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    padding: const EdgeInsets.all(8),
    child: const Icon(Icons.error, color: BaseColors.red),
  );
}
