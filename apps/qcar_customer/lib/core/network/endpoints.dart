import 'package:qcar_customer/core/environment_config.dart';

const String BACKEND_V1 = "/api/v1";

String urlPrefix(String endpoint) =>
    "${EnvironmentConfig.backendUrl}$BACKEND_V1$endpoint";

String get FEEDBACK_URL => urlPrefix("/feedback");
