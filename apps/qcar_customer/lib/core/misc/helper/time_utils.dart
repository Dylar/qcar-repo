const MILLI_PER_SEC = 1000;
const SEC_PER_MIN = MILLI_PER_SEC * 60;
const MIN_PER_HOUR = SEC_PER_MIN * 60;
const HOUR_PER_DAY = MIN_PER_HOUR * 24;
const DAY_PER_WEEK = HOUR_PER_DAY * 7;
const DAY_PER_MONTH_30 = HOUR_PER_DAY * 30;
const DAY_PER_MONTH_31 = HOUR_PER_DAY * 31;
const DAY_PER_YEAR = HOUR_PER_DAY * 365;

Future waitDiff(DateTime start) async {
  final diff = DateTime.now().difference(start).inMilliseconds;
  final rest = MILLI_PER_SEC * 2 - diff;
  if ((rest > 0)) {
    await Future.delayed(Duration(milliseconds: rest));
  }
}
