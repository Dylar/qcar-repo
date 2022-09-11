import 'dart:convert';

import 'package:qcar_customer/core/models/model_data.dart';
import 'package:qcar_customer/core/models/utils.dart';

class Feedback {
  Feedback(this.date, this.text, this.rating);

  final DateTime date;
  final String text;
  final int rating;

  Map<String, dynamic> toMap() => {
        FIELD_DATE: formatDate(date),
        FIELD_TEXT: text,
        FIELD_RATING: rating,
      };

  String toJson() => jsonEncode(toMap());
}
