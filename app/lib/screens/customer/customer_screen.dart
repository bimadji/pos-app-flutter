import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: Text(
            'Customer Screen',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.orangePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
