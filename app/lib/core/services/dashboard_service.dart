import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl = "http://10.0.2.2/pos_api";

  Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(Uri.parse("$baseUrl/dashboard/get_dashboard_stats.php"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }
}
