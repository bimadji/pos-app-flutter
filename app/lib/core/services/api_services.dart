import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/pos_api';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/get_products.php'));
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['products'];
    } else {
      throw Exception('Failed to load products');
    }
  }
}
