import 'package:qcar_customer/core/environment_config.dart';

const String API_PREFIX = "/api";
const String BACKEND_V1 = "/v1";

String urlPrefix(String endpoint) =>
    "${EnvironmentConfig.backendUrl}$API_PREFIX$BACKEND_V1$endpoint";

String get FEEDBACK_URL => urlPrefix("/feedback");
String get TRACKING_URL => urlPrefix("/tracking");

String get SELL_INFO_URL => urlPrefix("/sellInfo");
String get CAR_INFO_URL => urlPrefix("/carInfo");
String get CATEGORY_INFO_URL => urlPrefix("/categoryInfo");
String get VIDEO_INFO_URL => urlPrefix("/videoInfo");
