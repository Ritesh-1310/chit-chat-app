import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class FriendshipService {
  static const String _baseUrl = '$BASE_API_URL/friendships';

  // Send a friend request
  Future<Map<String, dynamic>> sendFriendRequest(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Accept a friend request
  Future<Map<String, dynamic>> acceptFriendRequest(String requestId, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/accept/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Reject a friend request
  Future<Map<String, dynamic>> rejectFriendRequest(String requestId, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/reject/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Get all friends for a user
  Future<List<Map<String, dynamic>>> getFriends(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/friends?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> friends = jsonDecode(response.body);
      return friends.map((friend) => friend as Map<String, dynamic>).toList();
    } else {
      return [];
    }
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
