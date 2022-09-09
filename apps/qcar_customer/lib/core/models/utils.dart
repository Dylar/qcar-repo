import 'package:intl/intl.dart';

String formatDate(DateTime date) =>
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(date);
