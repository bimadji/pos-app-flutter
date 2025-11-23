import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/rating.dart';

class RatingService {
  static const String baseUrl = "http://192.168.1.10/pos_api/ratings";

  Future<List<Rating>> getAllRatings() async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/get_all_rating.php"));

      print("GET ALL RATINGS STATUS: ${response.statusCode}");
      print("GET ALL RATINGS BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (body["success"] == true) {
        final List list = body["data"];
        return list.map((e) => Rating.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("GET ALL RATINGS ERROR: $e");
      return [];
    }
  }
}
