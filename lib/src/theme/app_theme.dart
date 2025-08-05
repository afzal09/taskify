import 'package:flutter/material.dart';
import 'package:whatbytes_assignment/src/theme/theme_values.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor, // seed
      primary: AppColors.primaryColor, // Beige buttons
      onPrimary: AppColors.whiteColor, // White text on beige buttons
      secondary:
          AppColors.secondaryColor, // secondary elements
      onSecondary: AppColors.whiteColor, // White text on secondary elements
      tertiary: AppColors.accentColor, // Olive Green for FAB/accents
      onTertiary: AppColors.whiteColor, // White text/icons on accents
      surface: AppColors.cardColor, // White card surfaces
      onSurface: AppColors.blackColor, // Black text on white surfaces
      error: AppColors.errorColor, // Red for errors
      onError: AppColors.whiteColor, // White text on errors
    ),
    // AppBar Theme - white to blend with background
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor, // White AppBar
      foregroundColor: AppColors.blackColor, // Black text/icons
      elevation: 0, // Flat design for clean look
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.blackColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ElevatedButton Theme - Beige background, dark text
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor, // Beige buttons
        foregroundColor: AppColors.whiteColor, // White text on buttons
        elevation: 4, // Subtle shadow for buttons
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    // TextButton Theme - Primary color text
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor, // Beige for text buttons
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ),
    // Input Decoration Theme (for TextFormField, TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGreyColor, // Very light grey fill
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none, // No default border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColors.accentColor,
          width: 2,
        ), // Olive green focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.greyColor),
      hintStyle: TextStyle(color: AppColors.greyColor),
      prefixIconColor: AppColors.greyColor,
      suffixIconColor: AppColors.greyColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    // Floating Action Button Theme - Olive Green
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentColor, // Olive Green FAB
      foregroundColor: AppColors.whiteColor, // White icon/text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      elevation: 8,
    ),
    // CircularProgressIndicator color
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryColor, // Beige progress indicators
    ),
  );
}
