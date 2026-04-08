import 'dart:convert';

import 'package:comfi/core/network/app_exception.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$normalizedBase$normalizedPath',
    ).replace(queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _client.get(
      _buildUri(path, queryParameters),
      headers: headers,
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      _buildUri(path),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return <String, dynamic>{};
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{'data': decoded};
    }

    throw ServerException(
      'Request failed with status ${response.statusCode}',
      statusCode: response.statusCode,
    );
  }
}
