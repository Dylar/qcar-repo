import 'dart:convert';

import 'package:qcar_customer/core/models/model_data.dart';
import 'package:qcar_customer/core/models/utils.dart';

class Feedback {
  Feedback(this.date, this.text);

  final DateTime date;
  final String text;

  Map<String, dynamic> toMap() => {
        FIELD_DATE: formatDate(date),
        FIELD_TEXT: text,
      };

  String toJson() => jsonEncode(toMap());
}
