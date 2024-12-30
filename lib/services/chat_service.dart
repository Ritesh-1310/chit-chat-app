import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ChatService {
  static const String _baseUrl = '$BASE_API_URL/chats';

  // Create a new chat
  Future<Map<String, dynamic>> createChat(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Get a chat by ID
  Future<Map<String, dynamic>> getChatById(String chatId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Get all chats for a user
  Future<List<Map<String, dynamic>>> getChatsForUser(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/chats?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> chats = jsonDecode(response.body);
      return chats.map((chat) => chat as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  // Add a message to a chat
  Future<Map<String, dynamic>> addMessageToChat(String chatId, Map<String, dynamic> message, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$chatId/add-message'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(message),
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
