import 'dart:convert';

import 'package:qcar_customer/models/model_data.dart';
import 'package:qcar_customer/models/utils.dart';

class TrackEvent {
  const TrackEvent(this.date, this.type, this.text);

  final DateTime date;
  final String type;
  final String text;

  Map<String, dynamic> toMap() => {
        FIELD_DATE: formatDate(date),
        FIELD_TYPE: type,
        FIELD_TEXT: text,
      };

  String toJson() => jsonEncode(toMap());
}
