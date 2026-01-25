import 'package:flutter/material.dart';

/// Palette de couleurs de l’application SecondMain 237
/// Basée sur les designs fournis avec le rose/magenta principal
class AppColors {
  AppColors._();

// Couleurs Principales
  static const Color primary = Color(0xFFE91E63); // Rose/Magenta principal
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color primaryLight = Color(0xFFF8BBD0);

  static const Color secondary = Color(0xFFFF9E80); // Orange/Saumon
  static const Color secondaryDark = Color(0xFFFF6E40);
  static const Color secondaryLight = Color(0xFFFFCCBC);

// Couleurs de fond
  static const Color background = Color(0xFFFAF5F9); // Fond rose très clair
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F5F5);

// Couleurs pour les illustrations (basées sur les images)
  static const Color illustrationYellow = Color(0xFFFFF9C4);
  static const Color illustrationPink = Color(0xFFFCE4EC);
  static const Color illustrationBlue = Color(0xFFB3E5FC);
  static const Color illustrationPeach = Color(0xFFFFE0B2);
  static const Color illustrationMint = Color(0xFFB2DFDB);

// Couleurs de Texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);

// Couleurs d’État
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

// Couleurs Neutres
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

// Couleurs pour les Champs de Saisie
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputBorderFocused = primary;
  static const Color inputFill = Color(0xFFFAFAFA);

// Couleurs pour les Ombres
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

// Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

// Couleurs pour les catégories d’annonces
  static const List<Color> categoryColors = [
    Color(0xFFFFE0B2), // Électronique
    Color(0xFFFFF9C4), // Mobilier
    Color(0xFFFCE4EC), // Mode
    Color(0xFFB3E5FC), // Automobile
    Color(0xFFB2DFDB), // Enfants
    Color(0xFFE1BEE7), // Maison
    Color(0xFFC5CAE9), // Sport
    Color(0xFFDCEDC8), // Divers
  ];

  /// Retourne une couleur aléatoire pour les catégories
  static Color getCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }
}