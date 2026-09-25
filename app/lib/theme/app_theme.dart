import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color orangePrimary = Color(0xFFDF8A2F); // oranye utama
  static const Color orangeLight = Color(0xFFF6E8D7);
  static const Color cream = Color(0xFFF8F1E8);
  static const Color darkText = Color(0xFF26321F);
  static const Color cardWhite = Color(0xFFFFFFFF);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.orangePrimary,
  scaffoldBackgroundColor: AppColors.cream,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orangePrimary),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: AppColors.darkText,
    displayColor: AppColors.darkText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.orangePrimary,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
