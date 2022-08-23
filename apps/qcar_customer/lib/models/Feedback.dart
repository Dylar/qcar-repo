import 'package:qcar_customer/models/model_data.dart';

class Feedback {
  Feedback(this.date, this.text);

  final DateTime date;
  final String text;

  Map<String, dynamic> toMap() => {
        FIELD_DATE: date.toString(),
        FIELD_TEXT: text,
      };
}
