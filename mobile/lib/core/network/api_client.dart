import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../error/failures.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  Future<dynamic> get(String path) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl$path'));
      return _handleResponse(response);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _client.delete(Uri.parse('$baseUrl$path'));
      return _handleResponse(response);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw ServerFailure(
      'Server error: ${response.statusCode}',
      statusCode: response.statusCode,
    );
  }
}
