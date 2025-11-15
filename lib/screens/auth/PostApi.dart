import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApi {
  static const String baseUrl = "https://route-movie-apis.vercel.app/";

  static Uri _buildUri(String endpoint) {
    return Uri.parse("$baseUrl$endpoint");
  }

  static Map<String, String> get _defaultHeaders => {
        "Content-Type": "application/json",
      };

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      _buildUri(endpoint),
      headers: _defaultHeaders,
      body: jsonEncode(body),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.patch(
      _buildUri(endpoint),
      headers: _defaultHeaders,
      body: jsonEncode(body),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      _buildUri(endpoint),
      headers: _defaultHeaders,
      body: jsonEncode(body),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      _buildUri(endpoint),
      headers: _defaultHeaders,
    );

    return _decodeResponse(response);
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      decoded["statusCode"] = response.statusCode;
      return decoded;
    }

    return {
      "statusCode": response.statusCode,
      "data": decoded,
    };
  }
}
