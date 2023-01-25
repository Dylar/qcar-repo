import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:qcar_shared/utils/logger.dart';

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
    this.urlPath,
  }) : header = header ?? _defaultHeaders();

  final RequestType requestType;
  final String url;
  final Map<String, String> header;
  final String? body;
  final Map<String, String>? queryParam;
  final List<String>? urlPath;
}

enum ResponseStatus { OK, NOT_FOUND, ERROR, NO_RESPONSE, UNKNOWN }

class Response {
  Response(this.status, {this.json = "", this.error = ""});

  Response.ok({required String json}) : this(ResponseStatus.OK, json: json);

  Response.error(String error) : this(ResponseStatus.ERROR, error: error);

  final ResponseStatus status;
  final String json;
  final String error;

  Map<String, dynamic> get jsonMap => jsonDecode(json);
  List<dynamic> get jsonList => jsonDecode(json);
}

class NetworkService {
  const NetworkService._();

  static Future<Response> sendRequest(Request request) async {
    try {
      const service = NetworkService._();
      final header = request.header;
      String url = service._concatUrlParams(request.url, request.queryParam);
      url = service._concatUrl(url, request.urlPath);

      final response = await service._createRequest(
          requestType: request.requestType,
          uri: Uri.parse(url),
          headers: header,
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

  String _concatUrl(String url, List<String>? urlPath) {
    if (url.isEmpty || urlPath == null || urlPath.isEmpty) {
      return url;
    }
    return "$url/${urlPath.join("/")}";
  }

  String _concatUrlParams(String url, Map<String, String>? queryParameters) {
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

    final ResponseStatus code;
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
        code = ResponseStatus.OK;
        break;
      case HttpStatus.notFound:
        code = ResponseStatus.NOT_FOUND;
        break;
      case HttpStatus.badRequest:
        code = ResponseStatus.ERROR;
        break;
      default:
        code = ResponseStatus.UNKNOWN;
        break;
    }

    return Response(
      code,
      json: response.body.isEmpty ? null : utf8.decode(response.bodyBytes),
    );
  }
}
