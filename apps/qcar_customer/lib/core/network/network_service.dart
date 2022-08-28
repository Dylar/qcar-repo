import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:qcar_customer/core/logger.dart';

enum RequestType { get, put, post }
enum CallBackParameterName { all, articles }

Map<String, String> _defaultHeaders() => {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Content-Type': 'application/x-www-form-urlencoded',
      // 'Content-Type': 'application/json',
    };

class Request {
  Request({
    required this.requestType,
    required this.url,
    Map<String, String>? header,
    this.body,
    this.queryParam,
  }) : this.header = header ?? _defaultHeaders();

  final RequestType requestType;
  final String url;
  final Map<String, String> header;
  final String? body;
  final Map<String, String>? queryParam;
}

enum ResponseStatus { OK, NOT_FOUND, ERROR, NO_RESPONSE, UNKNOWN }

class Response {
  Response(this.status, {this.jsonMap});

  Response.error(String error)
      : status = ResponseStatus.ERROR,
        jsonMap = {"error": error};

  final ResponseStatus status;
  final Map<String, dynamic>? jsonMap;

  String? get error => jsonMap?["error"];
}

class NetworkService {
  const NetworkService._();

  static Future<Response> sendRequest(Request request) async {
    try {
      final service = NetworkService._();
      final _header = request.header;
      final _url = service._concatUrl(request.url, request.queryParam);

      final response = await service._createRequest(
          requestType: request.requestType,
          uri: Uri.parse(_url),
          headers: _header,
          body: request.body);

      return service._evaluateResponse(response);
    } catch (e) {
      Logger.logE('$e');
      return Response.error(e.toString());
    }
  }

  Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    switch (requestType) {
      case RequestType.get:
        return http.get(uri, headers: headers);
      case RequestType.post:
        return http.post(uri, headers: headers, body: body);
      case RequestType.put:
        throw UnimplementedError();
    }
  }

  String _concatUrl(String url, Map<String, String>? queryParameters) {
    if (url.isEmpty || queryParameters == null || queryParameters.isEmpty) {
      return url;
    }
    final StringBuffer stringBuffer = StringBuffer("$url?");
    queryParameters.forEach((key, value) {
      if (value.trim() == '') return;
      if (value.contains(' ')) throw Exception('Invalid Input Exception');
      stringBuffer.write('$key=$value&');
    });
    final result = stringBuffer.toString();
    return result.substring(0, result.length - 1);
  }

  Response _evaluateResponse(http.Response? response) {
    if (response == null) {
      return Response(ResponseStatus.NO_RESPONSE);
    }

    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
        return Response(
          ResponseStatus.OK,
          jsonMap: response.body.isEmpty ? null : jsonDecode(response.body),
        );
      case HttpStatus.notFound:
        return Response(
          ResponseStatus.NOT_FOUND,
          jsonMap: jsonDecode(response.body),
        );
      case HttpStatus.badRequest:
        return Response(
          ResponseStatus.ERROR,
          jsonMap: jsonDecode(response.body),
        );
      default:
        return Response(
          ResponseStatus.UNKNOWN,
          jsonMap: jsonDecode(response.body),
        );
    }
  }
}
