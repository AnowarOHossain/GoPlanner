import 'package:flutter/material.dart';

// This file defines all colors used in the app
// Keep colors in one place for easy customization
class AppColors {
  // Main brand colors
  static const Color primary = Color(0xFF2E7D5A); // Main green color
  static const Color primaryLight = Color(0xFF4CAF50); // Light green
  static const Color primaryDark = Color(0xFF1B5E20); // Dark green
  
  // Secondary accent colors
  static const Color secondary = Color(0xFFFFA726); // Orange
  static const Color secondaryLight = Color(0xFFFFCC02); // Light orange
  static const Color secondaryDark = Color(0xFFFF8F00); // Dark orange
  
  // Neutral colors (black, white, grey shades)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5); // Lightest grey
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E); // Medium grey
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121); // Darkest grey
  
  // Status and notification colors
  static const Color success = Color(0xFF4CAF50); // Green for success messages
  static const Color warning = Color(0xFFFFC107); // Yellow for warnings
  static const Color error = Color(0xFFf44336); // Red for errors
  static const Color info = Color(0xFF2196F3); // Blue for information
  
  // Background colors for different surfaces
  static const Color background = Color(0xFFFAFAFA); // Main background
  static const Color surface = Color(0xFFFFFFFF); // Card surfaces
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Category specific colors
  static const Color hotel = Color(0xFF3F51B5); // Blue for hotels
  static const Color restaurant = Color(0xFFE91E63); // Pink for restaurants
  static const Color attraction = Color(0xFF9C27B0); // Purple for attractions
  
  // Rating star colors
  static const Color ratingGold = Color(0xFFFFD700); // Gold for filled stars
  static const Color ratingEmpty = Color(0xFFE0E0E0); // Grey for empty stars
  
  // Gradient effects for visual appeal
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, grey100],
  );
}