// Import Flutter material design
import 'package:flutter/material.dart';
// Import app colors
import '../../core/constants/app_colors.dart';

// App theme configuration - defines the look and feel of the entire app
class AppTheme {
  // Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Use latest Material Design
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins', // Default font for the app
      
      // AppBar styling (top navigation bar)
      appBarTheme: const AppBarTheme(
        elevation: 0, // No shadow by default
        scrolledUnderElevation: 1, // Small shadow when scrolled
        centerTitle: true, // Center the title
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.grey900,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Card styling (for hotel cards, restaurant cards, etc.)
      cardTheme: CardThemeData(
        elevation: 2, // Slight shadow
        shadowColor: AppColors.grey400.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        color: AppColors.white,
      ),
      
      // Bottom navigation bar styling (Home, Explore, Cart, Profile)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary, // Active item color
        unselectedItemColor: AppColors.grey500, // Inactive item color
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: AppColors.grey100,
        hintStyle: const TextStyle(
          color: AppColors.grey500,
          fontFamily: 'Poppins',
        ),
        labelStyle: const TextStyle(
          color: AppColors.grey700,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey200,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.grey300,
        labelStyle: const TextStyle(
          color: AppColors.grey800,
          fontFamily: 'Poppins',
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.white,
          fontFamily: 'Poppins',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey300,
        thickness: 1,
        space: 1,
      ),
      
      // Scaffold Background Color
      scaffoldBackgroundColor: AppColors.background,
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
      
      // Dark theme specific customizations
      scaffoldBackgroundColor: AppColors.grey900,
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.grey800,
        foregroundColor: AppColors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontFamily: 'Poppins',
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.grey800,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.grey800,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.grey400,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}

// Text Styles
class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    fontFamily: 'Poppins',
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey700,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
    fontFamily: 'Poppins',
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey800,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey700,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey600,
    fontFamily: 'Poppins',
  );
  
  // Captions
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
    fontFamily: 'Poppins',
  );
  
  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
}