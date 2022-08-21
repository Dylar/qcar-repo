import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/Feedback.dart';
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/service/settings_service.dart';

class UploadService {
  UploadService(this.settingsService, this.uploadClient);

  SettingsService settingsService;
  UploadClient uploadClient;

  void sendFeedback(String? text) {
    final feedback = Feedback(DateTime.now(), text ?? '');
    uploadClient.sendFeedback(feedback);
  }

  void sendTracking(TrackEvent? event) {
    assert(event != null);
    if (settingsService.isTrackingEnabled()) {
      uploadClient.sendTracking(event!);
    }
  }
}
