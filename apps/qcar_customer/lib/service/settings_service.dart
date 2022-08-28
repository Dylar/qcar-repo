import 'package:shared_preferences/shared_preferences.dart';

const KEY_TRACKING_ENABLED = "tracking_enabled";

class SettingsService {
  SettingsService(this._sharedPref);

  SharedPreferences _sharedPref;

  bool isTrackingEnabled() => _sharedPref.getBool(KEY_TRACKING_ENABLED) ?? true;
}
