class TrackEvent {
  const TrackEvent(this.type, this.message);

  final String type;
  final String message;
}

class Logger {
  static void logI(String msg) {
    log("Logging", msg, false);
  }

  static void logD(String msg, {bool printTrace = false}) {
    log("DELETE ME", msg, printTrace);
  }

  static void logE(String msg, {bool printTrace = false}) {
    log("Error", msg, printTrace);
  }

  static void logF(String msg) {
    log("Feedback", msg, false);
  }

  static void logTrack(String msg) {
    log("Tracking", msg, false);
  }

  static void logTest(String msg, {bool printTrace = false}) {
    log("Test", msg, printTrace);
  }

  static void log(String tag, msg, bool printTrace) {
    print("$tag: $msg");
    if (printTrace) print(StackTrace.current);
  }
}
