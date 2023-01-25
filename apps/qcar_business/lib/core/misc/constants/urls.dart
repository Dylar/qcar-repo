import 'package:qcar_business/core/environment_config.dart';

const String API_PREFIX = "/api";
const String BACKEND_V1 = "/v1";

String urlPrefix(String endpoint) =>
    "${EnvironmentConfig.backendUrl}$API_PREFIX$BACKEND_V1$endpoint";

String get FEEDBACK_URL => urlPrefix("/feedback");
String get TRACKING_URL => urlPrefix("/tracking");

String get CAR_INFO_URL => urlPrefix("/car");
String get DEALER_INFO_URL => urlPrefix("/dealer");
