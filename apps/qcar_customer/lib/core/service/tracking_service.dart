import 'package:flutter/cupertino.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/core/models/Feedback.dart';
import 'package:qcar_customer/core/models/Tracking.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/core/service/services.dart';
import 'package:qcar_customer/core/service/settings_service.dart';

void sendTracking(BuildContext context, TrackType? type, String? text) {
  Services.of(context)!.trackingService.sendTracking(type, text);
}

class TrackingService {
  TrackingService(this._settingsService, this._uploadClient);

  SettingsService _settingsService;
  UploadClient _uploadClient;

  Future<Response> sendFeedback(String? text, int? rating) async {
    final feedback = Feedback(DateTime.now(), text ?? '', rating ?? 0);
    return _uploadClient.sendFeedback(feedback);
  }

  void sendTracking(TrackType? type, String? text) {
    if (EnvironmentConfig.isDev) {
      return;
    }

    _settingsService.isTrackingEnabled().then((enabled) {
      final tracking =
          TrackEvent(DateTime.now(), type ?? TrackType.ERROR, text ?? "");
      if (enabled) {
        Logger.logTrack(tracking.text);
        _uploadClient.sendTracking(tracking);
      }
    });
  }
}
