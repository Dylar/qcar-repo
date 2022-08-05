import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/Feedback.dart';
import 'package:qcar_customer/models/Tracking.dart';

class UploadService {
  UploadService(this.uploadClient);

  UploadClient uploadClient;

  void sendFeedback(Feedback? feedback) {
    assert(feedback != null);
    uploadClient.sendFeedback(feedback!);
  }

  void sendTracking(TrackEvent? event) {
    assert(event != null);
    uploadClient.sendTracking(event!);
  }
}
