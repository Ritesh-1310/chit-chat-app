import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  final String _baseUrl = BASE_API_URL; // Replace with your server URL
  String? _authToken;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // Save token
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // Register a new user
  Future<void> register(String fullName, String userName, String email,
      String password, String dob, String gender) async {
    final uri = Uri.parse('$_baseUrl/auth/register');
    final body = jsonEncode({
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'password': password,
      'dob': dob,
      'gender': gender,
    });
    try {
      final response =
          await http.post(uri, headers: _buildHeaders(), body: body);

      if (response.statusCode == 201) {
        // Registration successful
        print("User registered successfully.");
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Register request failed: $e');
    }
  }

  // Login user
  Future<void> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final body = jsonEncode({'email': email, 'password': password});
    try {
      final response =
          await http.post(uri, headers: _buildHeaders(), body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        setAuthToken(token);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login request failed: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    final uri = Uri.parse('$_baseUrl/auth/logout');
    try {
      final response =
          await http.post(uri, headers: _buildHeaders(), body: jsonEncode({}));

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Logout request failed: $e');
    }
  }

  // Fetch the logged-in user's profile as a User object
  Future<User> getUserProfile() async {
    final uri = Uri.parse('$_baseUrl/users/profile');
    try {
      final response = await http.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to fetch user profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request to fetch user profile failed: $e');
    }
  }
}
