import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class GroupService {
  static const String _baseUrl = '$BASE_API_URL/api/groups';

  // Create a new group
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> data, String token) async {
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

  // Get group by ID
  Future<Map<String, dynamic>> getGroupById(String groupId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$groupId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Add a message to a group
  Future<Map<String, dynamic>> addMessageToGroup(String groupId, Map<String, dynamic> message, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$groupId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(message),
    );
    return _handleResponse(response);
  }

  // Add a member to a group
  Future<Map<String, dynamic>> addMemberToGroup(String groupId, String memberId, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$groupId/add-member'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'memberId': memberId}),
    );
    return _handleResponse(response);
  }

  // Delete a group
  Future<Map<String, dynamic>> deleteGroup(String groupId, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$groupId'),
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
