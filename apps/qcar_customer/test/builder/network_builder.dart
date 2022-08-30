import 'package:qcar_customer/core/network/network_service.dart';

Response okResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.OK, jsonMap: jsonMap);
}

Response notFoundResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.NOT_FOUND, jsonMap: jsonMap);
}

Response errorResponse(String error) {
  return Response.error(error);
}

Response noResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.NO_RESPONSE, jsonMap: jsonMap);
}

Response unknownResponse({Map<String, dynamic>? jsonMap}) {
  return Response(ResponseStatus.UNKNOWN, jsonMap: jsonMap);
}
