import 'package:flutter/material.dart';
import 'package:qcar_business/ui/app_theme.dart';

Widget buildImageError(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  print(StackTrace.current);
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    padding: EdgeInsets.all(8),
    child: Icon(Icons.error, color: BaseColors.red),
  );
}
