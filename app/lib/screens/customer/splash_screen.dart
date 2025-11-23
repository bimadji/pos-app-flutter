import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../customer/customer_form_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Judul
            Text(
              'POS Bahasa Pemrograman',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text('POS Customer',
                style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 40),

            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'LOGIN KARYAWAN',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerFormScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange, // biar beda
                ),
                child: const Text(
                  'ISI DATA CUSTOMER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
