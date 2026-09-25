import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://192.168.1.10/pos_api"; //Wifi Kos
  // final String baseUrl = "http://10.156.127.235/pos_api"; //Hostpot HP

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login.php');

    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> resetPassword(String username, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/reset_password.php');

    final response = await http.post(
      url,
      body: {
        'username': username,
        'new_password': newPassword,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> register(
      String username,
      String name,
      String email,
      String password,
      String role) async {
    final url = Uri.parse('$baseUrl/auth/register.php');

    final response = await http.post(
      url,
      body: {
        'username': username,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
