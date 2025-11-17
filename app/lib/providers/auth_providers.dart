import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Simulasi user data (bisa diganti API nanti)
  final Map<String, String> _admin = {'username': 'admin', 'password': 'admin123'};
  final Map<String, String> _kasir = {'username': 'kasir', 'password': 'kasir123'};

  Future<String?> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulasi loading

    _isLoading = false;
    notifyListeners();

    if (username == _admin['username'] && password == _admin['password']) {
      return 'admin';
    } else if (username == _kasir['username'] && password == _kasir['password']) {
      return 'kasir';
    } else {
      return null;
    }
  }
}
