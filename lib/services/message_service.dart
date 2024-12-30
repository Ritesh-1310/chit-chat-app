import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class MessageService {
  static const String _baseUrl = '$BASE_API_URL/messages';

  // Send a new message
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Get a message by ID
  Future<Map<String, dynamic>> getMessageById(String messageId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$messageId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Delete a message
  Future<Map<String, dynamic>> deleteMessage(String messageId, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$messageId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Helper method to handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'error': jsonDecode(response.body)['message']};
    }
  }
}
