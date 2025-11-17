import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_providers.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(), // 👈 LoginScreen nanti ada di sini
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS F&B',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const LoginScreen(), // ✅ sudah di bawah provider
    );
  }
}
