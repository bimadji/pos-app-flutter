// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_providers.dart';
// import 'screens/auth/login_screen.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
//       child: const MyApp(), // 👈 LoginScreen nanti ada di sini
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'POS F&B',
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: const LoginScreen(), // ✅ sudah di bawah provider
//     );
//   }
// }

import 'package:app/screens/customer/splash_screen.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <- wajib sebelum SharedPreferences
  runApp(const PosApp());
}


class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Orange Customer',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // <- PAKE const juga tidak masalah
    );
  }
}
