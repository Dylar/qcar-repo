import 'package:qcar_customer/service/tracking_service.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';

mixin FeedbackFun implements FeedbackViewModel {
  TrackingService get trackingService;

  void sendFeedback(String text) {
    trackingService.sendFeedback(Feedback(DateTime.now(), text));
  }
}

class Feedback {
  Feedback(this.date, this.text);

  DateTime date;
  String text;
}
