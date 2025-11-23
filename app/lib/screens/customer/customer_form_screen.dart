import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../customer/home_screen.dart';
import '../../theme/app_theme.dart';

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({super.key});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final tableController = TextEditingController();
  final phoneController = TextEditingController(); // ← Tambahan field nomor HP

  bool loading = false;

  Future<void> submitCustomer() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        tableController.text.isEmpty ||
        phoneController.text.isEmpty) { // ← cek nomor HP juga
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    final url = Uri.parse("http://10.0.2.2/pos_api/customers/insert_customers.php");

    final response = await http.post(url, body: {
      "name": nameController.text,
      "email": emailController.text,
      "table_number": tableController.text,
      "phone": phoneController.text, // ← kirim ke API
    });
    print("RESPONSE FROM SERVER: ${response.body}");
    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("customer_name", nameController.text);
      await prefs.setString("customer_email", emailController.text);
      await prefs.setInt("customer_table", int.parse(tableController.text));
      await prefs.setString("customer_phone", phoneController.text); // ← simpan nomor HP
      await prefs.setInt("customer_id", data["customer_id"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Gagal menyimpan")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text("Isi Data Customer"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Customer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: phoneController, // ← Field nomor HP
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Nomor HP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: tableController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nomor Meja",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submitCustomer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "LANJUT KE HOME",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
