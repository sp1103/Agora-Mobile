import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class NetworkHelper {
  static Future<http.Response> safeGet(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw NetworkException("Server error (${response.statusCode})");
      }
      return response;
    } on TimeoutException {
      throw NetworkException("Request timed out. Please check your internet connection.");
    } on http.ClientException {
      throw NetworkException("Network error. Please check your internet connection.");
    } on Exception catch (e) {
      throw NetworkException("Unexpected error: $e");
    }
  }

  static Future<http.Response> safePost(Uri url, Object body) async {
    try {
      final response = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw NetworkException("Server error (${response.statusCode})");
      }

      return response;
    } on TimeoutException {
      throw NetworkException("Request timed out. Please check your internet connection.");
    } on http.ClientException {
      throw NetworkException("Network error. Please check your internet connection.");
    } on Exception catch (e) {
      throw NetworkException("Unexpected error: $e");
    }
  }
}
