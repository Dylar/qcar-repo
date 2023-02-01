import 'dart:convert';

import 'package:qcar_shared/network_service.dart';

Response okResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.OK, json: jsonEncode(jsonMap));
}

Response notFoundResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.NOT_FOUND, json: jsonEncode(jsonMap));
}

Response errorResponse(String error) {
  return Response.error(error);
}

Response noResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.NO_RESPONSE, json: jsonEncode(jsonMap));
}

Response unknownResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.UNKNOWN, json: jsonEncode(jsonMap));
}
