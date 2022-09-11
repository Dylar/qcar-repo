import 'package:hive/hive.dart';

import 'model_data.dart';

part 'settings.g.dart';

@HiveType(typeId: SETTINGS_TYPE_ID)
class Settings extends HiveObject {
  @HiveField(0)
  Map<String, String> values = {};
  @HiveField(1)
  Map<String, bool> videos = {};
  @HiveField(2)
  bool? isTrackingEnabled;
}
