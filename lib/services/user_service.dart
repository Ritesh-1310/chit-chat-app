import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class UserService {
  final String _baseUrl = BASE_API_URL;
  String? _authToken;

  Future<void> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token'); // Retrieve token
    // print('userAuthToken1: $_authToken'); ////
  }

  // Public getter for _authToken
  String? get authToken => _authToken;

  Map<String, String> _buildHeaders() {
    // print('userAuthToken2: $_authToken'); ////

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
      'Cookie': 'token=$_authToken'
    };
    return requestHeaders;
  }

  // Fetch the logged-in user's profile as a User object
  Future<User> getUserProfile() async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users/profile');
    try {
      final response = await http.get(uri, headers: _buildHeaders());
      if (response.statusCode == 200) {
        // print('profile: ${jsonDecode(response.body)}, ${response.statusCode}');
        final data = jsonDecode(response.body);
        // print('User (raw JSON): $data');
        return User.fromJson(data);
      } else {
        throw Exception('Failed to fetch user profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to fetch user profile failed: $e');
    }
  }

  // Update the logged-in user's profile
  Future<void> updateUserProfile(User updatedUser) async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users/profile');
    try {
      final response = await http.put(
        uri,
        headers: _buildHeaders(),
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to update profile failed: $e');
    }
  }

  // Change the logged-in user's password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users/change-password');
    final body = jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    try {
      final response =
          await http.put(uri, headers: _buildHeaders(), body: body);

      if (response.statusCode != 200) {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to change password failed: $e');
    }
  }

  // Get all users as a list of User objects
  Future<List<User>> getAllUsers() async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users');
    try {
      final response = await http.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<User>.from(data.map((userJson) => User.fromJson(userJson)));
      } else {
        throw Exception('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to fetch all users failed: $e');
    }
  }

  // Get a user by ID as a User object
  Future<User> getUserById(String userId) async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users/$userId');
    try {
      final response = await http.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to fetch user by ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to fetch user by ID failed: $e');
    }
  }

  // Delete a user by ID
  Future<void> deleteUser(String userId) async {
    await getAuthToken(); // Await the token retrieval
    final uri = Uri.parse('$_baseUrl/users/$userId');
    try {
      final response = await http.delete(uri, headers: _buildHeaders());

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to delete user failed: $e');
    }
  }
}
