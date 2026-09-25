import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product.dart';
import '../../models/rating.dart';

class ProductService {
  static const String baseUrl = "http://192.168.1.10/pos_api/products";
  // static const String baseUrl = "http://10.156.127.235/pos_api/products";

  Future<List<Product>> getProducts() async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/get_products.php"));

      print("API PRODUCT STATUS: ${response.statusCode}");
      print("API PRODUCT BODY: ${response.body}");

      final jsonData = jsonDecode(response.body);

      if (jsonData["success"] == true) {
        List data = jsonData["data"];
        return data.map((p) => Product.fromJson(p)).toList();
      }

      return [];
    } catch (e) {
      print("GET PRODUCTS ERROR: $e");
      return [];
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/add_product.php"),
        body: {
          "name": product.name,
          "category": product.category,
          "price": product.price.toString(),
          "stock": product.stock.toString(),
        },
      );

      print("ADD PRODUCT RESPONSE: ${res.body}");

      return jsonDecode(res.body)["success"] == true;
    } catch (e) {
      print("ADD PRODUCT ERROR: $e");
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/delete_product.php"),
        body: {"id": id.toString()},
      );

      print("DELETE PRODUCT RESPONSE: ${res.body}");

      return jsonDecode(res.body)["success"] == true;
    } catch (e) {
      print("DELETE PRODUCT ERROR: $e");
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_product.php"),
        body: {
          "id": product.id.toString(),
          "name": product.name,
          "category": product.category,
          "price": product.price.toString(),
          "stock": product.stock.toString(),
        },
      );

      print("UPDATE RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("UPDATE ERROR: $e");
      return false;
    }
  }
}
