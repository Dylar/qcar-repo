import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/Feedback.dart';
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/service/settings_service.dart';

class UploadService {
  UploadService(this.settingsService, this.uploadClient);

  SettingsService settingsService;
  UploadClient uploadClient;

  Future<Response> sendFeedback(String? text) async {
    final feedback = Feedback(DateTime.now(), text ?? '');
    return uploadClient.sendFeedback(feedback);
  }

  void sendTracking(TrackEvent? event) {
    assert(event != null);
    if (settingsService.isTrackingEnabled()) {
      uploadClient.sendTracking(event!);
    }
  }
}
