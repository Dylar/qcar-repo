import 'dart:convert';

import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/models/utils.dart';

enum TrackType { NAVIGATION, INFO, ERROR }

class TrackEvent {
  const TrackEvent(this.date, this.type, this.text);

  final DateTime date;
  final TrackType type;
  final String text;

  Map<String, dynamic> toMap() => {
        FIELD_DATE: formatDate(date),
        FIELD_TYPE: type.name,
        FIELD_TEXT: text,
      };

  String toJson() => jsonEncode(toMap());
}
