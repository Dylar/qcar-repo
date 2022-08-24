import 'package:http/http.dart' as http;
import 'package:qcar_customer/core/logger.dart';
import 'package:qcar_customer/core/network/network_helper.dart';

enum RequestType { get, put, post }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() => {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Content-Type': 'application/x-www-form-urlencoded',
        // 'Content-Type': 'application/json',
      };

  static Future<http.Response>? _createRequest({
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

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    String? body,
    Map<String, String>? queryParam,
  }) async {
    try {
      final _header = _getHeaders();
      final _url = NetworkHelper.concatUrlQP(url, queryParam);

      final response = await _createRequest(
          requestType: requestType,
          uri: Uri.parse(_url),
          headers: _header,
          body: body);

      Logger.logD('Response: ${response?.headers}');

      return response;
    } catch (e) {
      Logger.logE('$e');
      return null;
    }
  }
}
