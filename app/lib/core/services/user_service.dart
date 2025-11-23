import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user.dart';

class UserService {
  static const String baseUrl = "http://192.168.1.10/pos_api/users";
  // static const String baseUrl = "http://10.156.127.235/pos_api/users";

  static Future<List<AppUser>> getUsers() async {
    final res = await http.get(Uri.parse("$baseUrl/get_users.php"));

    final data = jsonDecode(res.body);

    if (data["success"]) {
      return (data["data"] as List)
          .map((u) => AppUser.fromJson(u))
          .toList();
    } else {
      return [];
    }
  }

  static Future<bool> addUser(String name, String role) async {
    final res = await http.post(
      Uri.parse("$baseUrl/add_user.php"),
      body: {"name": name, "role": role},
    );

    return jsonDecode(res.body)["success"];
  }

  static Future<bool> deleteUser(String id) async {
    final res = await http.post(
      Uri.parse("$baseUrl/delete_user.php"),
      body: {"id": id},
    );

    return jsonDecode(res.body)["success"];
  }

  Future<Map<String, dynamic>> updateUser(AppUser user) async {
    final url = Uri.parse("$baseUrl/users/update_user.php");

    final response = await http.post(url, body: {
      "id": user.id.toString(),
      "name": user.name,
      "email": user.email,
      "role": user.role,
    });

    return jsonDecode(response.body);
  }


}
