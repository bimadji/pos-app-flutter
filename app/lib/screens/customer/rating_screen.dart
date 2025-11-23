import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';

class RatingScreen extends StatefulWidget {
  final Map<String, int> cart; // menuId -> qty
  final List<Product> menus;   // daftar menu lengkap

  const RatingScreen({super.key, required this.cart, required this.menus});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  late List<Map<String, dynamic>> _orderedMenus;
  late Map<String, int> _ratings;
  late Map<String, String> _comments;

  @override
  void initState() {
    super.initState();

    // ambil menu yang dipesan saja
    _orderedMenus = widget.menus
        .where((m) => widget.cart.containsKey(m.id.toString()))
        .map((m) => m.toJson())
        .toList();

    // inisialisasi rating & komentar
    _ratings = {for (final m in _orderedMenus) m['id'].toString(): 0};
    _comments = {for (final m in _orderedMenus) m['id'].toString(): ''};
  }

  void _setRating(String id, int value) {
    setState(() {
      _ratings[id] = value;
    });
  }

  void _setComment(String id, String value) {
    setState(() {
      _comments[id] = value;
    });
  }

  void _submitRating() async {
    final prefs = await SharedPreferences.getInstance();
    final customerName = prefs.getString("customer_name") ?? "Unknown";
    final tableNumber = prefs.getInt("customer_table") ?? 0;

    final ratingsData = _orderedMenus.map((menu) {
      final name = menu['name'].toString();
      final id = menu['id'].toString();
      return {
        'menu_name': name,
        'rating': _ratings[id] ?? 0,
        'comment': _comments[id] ?? '',
      };
    }).toList();

    final body = {
      'table_number': tableNumber,
      'customer_name': customerName,
      'ratings': ratingsData,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10/pos_api/ratings/save_rating.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          _orderedMenus = [];
          _ratings = {};
          _comments = {};
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Terima kasih'),
            content: const Text('Rating kamu sudah tersimpan.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Gagal menyimpan rating');
      }

    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan rating.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.orangePrimary,
        elevation: 0,
        title: const Text('Rating Menu'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Beri penilaian untuk setiap menu yang sudah kamu pesan.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),

            // LIST MENU YANG DIPESAN
            Expanded(
              child: _orderedMenus.isEmpty
                  ? const Center(
                child: Text(
                  'Belum ada pesanan untuk dinilai',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _orderedMenus.length,
                itemBuilder: (context, index) {
                  final menu = _orderedMenus[index];
                  final id = menu['id'].toString();
                  final name = menu['name'].toString();
                  final qty = widget.cart[id] ?? 1;
                  final rating = _ratings[id] ?? 0;
                  final comment = _comments[id] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama + qty
                        Text(
                          '$name (x$qty)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rating bintang
                        Row(
                          children: List.generate(5, (starIndex) {
                            final starValue = starIndex + 1;
                            final isActive = starValue <= rating;
                            return IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _setRating(id, starValue),
                              icon: Icon(
                                isActive ? Icons.star : Icons.star_border,
                                size: 24,
                                color: Colors.amber,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),

                        // Kolom komentar
                        TextField(
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Tulis komentar kamu di sini...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) => _setComment(id, value),
                          controller: TextEditingController(text: comment)
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: comment.length),
                            ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Tombol submit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _orderedMenus.isEmpty ? null : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Kirim Rating',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
