import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._(); 
  // Main Palette
  static const Color primaryColor = Color(0xFF6B68F6);
  static const Color accentColor = Color(0xFFE9E9F8); 
  static const Color secondaryColor = Color(0xFFFFB03C); 
  static const Color successColor = Color(0xFF4CAF50); 
  static const Color warningColor = Color(0xFFFF9800); 
  static const Color errorColor = Color(0xFFEF5350); 

  // Neutral Colors
  static const Color blackColor = Color(0xFF212121);
  static const Color whiteColor = Color(0xFFFFFFFF); 
  static const Color greyColor = Color(0xFFB5B3C8); 
  static const Color darkgreyColor = Color(0xFF2F2E41); 
  static const Color lightGreyColor = Color(0xFFF7F7FD); 

  // Backgrounds
  static const Color backgroundColor = Color(0xFFF7F7FD); 

  static const Color cardColor = Color(0xFFFFFFFF); 

  // Priority Colors
  static const Color highPriorityColor = Color(0xFFFE6B6B); 
  static const Color mediumPriorityColor = Color(0xFFFFB03C); 
  static const Color lowPriorityColor = Color(0xFF75C16C); 

  static const Color beigeColor = Color(0xFFFFE0B2); 
  static const Color lightBlueColor = Color(0xFFC5CAE9); 
  static const Color purpleColor = Color(0xFF6B68F6); 

  // Specific colors derived from the UI
  static const Color personalTagColor = Color(0xFFF4AF61);
  static const Color workTagColor = Color(0xFFFE6B6B);
  static const Color appsTagColor = Color(0xFF7B95F5);
  static const Color exerciseTagColor = Color(0xFF75C16C);

  // Gradient
  static const LinearGradient welcomeScreenGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF6373f7),
      Color(0xFF91e0fe),
    ],
  );
}