import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';


class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.backgroundLight,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
          onError: AppColors.textWhite,
        ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
    elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    ),

    // Text Theme
    textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    ),
    displayMedium: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    ),
    displaySmall: GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    headlineLarge: GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    headlineMedium: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    headlineSmall: GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    titleLarge: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    ),
    titleSmall: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    ),
    bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    ),
    bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    ),
    labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    ),
    labelMedium: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    ),
    labelSmall: GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: AppColors.inputBorder,
    width: 1,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: AppColors.inputBorder,
    width: 1,
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: AppColors.inputBorderFocused,
    width: 2,
    ),
    ),
    errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: AppColors.error,
    width: 1,
    ),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: AppColors.error,
    width: 2,
    ),
    ),
    hintStyle: GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textHint,
    ),
    labelStyle: GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textSecondary,
    ),
    errorStyle: GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.error,
    ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textWhite,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(
    color: AppColors.primary,
    width: 1.5,
    ),
    padding: const EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
    ),
    textStyle: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),

    // Card Theme
    cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    color: AppColors.backgroundLight,
    shadowColor: AppColors.shadow,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
    backgroundColor: AppColors.greyLight,
    selectedColor: AppColors.primary,
    labelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundLight,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    selectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textWhite,
    elevation: 4,
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    backgroundColor: AppColors.backgroundLight,
    titleTextStyle: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    ),
    contentTextStyle: GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textSecondary,
    ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
    color: AppColors.greyLight,
    thickness: 1,
    space: 1,
    ),
    );
    

  }
}