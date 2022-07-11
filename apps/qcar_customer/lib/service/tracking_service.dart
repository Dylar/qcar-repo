import 'package:qcar_customer/core/tracking.dart';
import 'package:qcar_customer/service/feedback_fun.dart';

class TrackingService {
  void sendFeedback(Feedback feedback) {
    Logger.logF(feedback.text);
  }
}
