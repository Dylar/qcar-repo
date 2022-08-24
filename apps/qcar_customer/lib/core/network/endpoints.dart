import 'package:qcar_customer/core/environment_config.dart';

const String API_PREFIX = "/api";
const String BACKEND_V1 = "/v1";

String urlPrefix(String endpoint) =>
    "${EnvironmentConfig.backendUrl}$API_PREFIX$BACKEND_V1$endpoint";

String get FEEDBACK_URL => urlPrefix("/feedback");
