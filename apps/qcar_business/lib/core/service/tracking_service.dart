import 'package:flutter/cupertino.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_business/core/service/services.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_shared/utils/logger.dart';

void sendTracking(BuildContext context, TrackType? type, String? text) {
  Services.of(context)!.trackingService.sendTracking(type, text);
}

class TrackingService {
  TrackingService(this._settingsService, this._uploadClient);

  SettingsService _settingsService;
  UploadClient _uploadClient;

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
