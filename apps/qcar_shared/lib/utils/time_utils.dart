import 'package:intl/intl.dart';

const MILLI_PER_SEC = 1000;
const SEC_PER_MIN = MILLI_PER_SEC * 60;
const MIN_PER_HOUR = SEC_PER_MIN * 60;
const HOUR_PER_DAY = MIN_PER_HOUR * 24;
const DAY_PER_WEEK = HOUR_PER_DAY * 7;
const DAY_PER_MONTH_30 = HOUR_PER_DAY * 30;
const DAY_PER_MONTH_31 = HOUR_PER_DAY * 31;
const DAY_PER_YEAR = HOUR_PER_DAY * 365;

String formatDate(DateTime date) =>
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(date);

String formatBirthday(DateTime date) => DateFormat("dd-MM-yyyy").format(date);

// Helper functions that not only awaits a future but also ensures
// that we wait at least for specific time
Future<T> atLeast<T>(
  Future<T> computation, {
  Duration duration = const Duration(seconds: 3),
}) async {
  final minTime = Future.delayed(duration);
  try {
    final T result = await computation;
    await minTime;
    return result;
  } catch (e) {
    await minTime;
    rethrow;
  }
}
