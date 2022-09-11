import 'package:qcar_customer/core/models/Feedback.dart';
import 'package:qcar_customer/core/models/Tracking.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';

class TrackingService {
  TrackingService(this._settingsService, this._uploadClient);

  SettingsService _settingsService;
  UploadClient _uploadClient;

  Future<Response> sendFeedback(String? text, int? rating) async {
    final feedback = Feedback(DateTime.now(), text ?? '', rating ?? 0);
    return _uploadClient.sendFeedback(feedback);
  }

  void sendTracking(TrackEvent? event) {
    assert(event != null);
    _settingsService.isTrackingEnabled().then((enabled) {
      if (enabled) {
        _uploadClient.sendTracking(event!);
      }
    });
  }
}
