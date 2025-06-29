import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wellness_colors.dart';

/// Modern wellness-focused theme for exceptional UX
/// Optimized for health, personalization, and accessibility
class WellnessTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme - Warm, friendly, accessible
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: WellnessColors.primaryGreen,
        onPrimary: Colors.white,
        secondary: WellnessColors.secondaryBlue,
        onSecondary: Colors.white,
        tertiary: WellnessColors.accentPeach,
        onTertiary: WellnessColors.textPrimary,
        surface: WellnessColors.backgroundPrimary,
        onSurface: WellnessColors.textPrimary,
        background: WellnessColors.neutralCream,
        onBackground: WellnessColors.textPrimary,
        error: WellnessColors.errorCoral,
        onError: Colors.white,
      ),

      // Typography - Rounded, friendly, readable
      textTheme: const TextTheme(
        displayLarge: WellnessTypography.displayLarge,
        displayMedium: WellnessTypography.displayMedium,
        headlineLarge: WellnessTypography.headlineLarge,
        headlineMedium: WellnessTypography.headlineMedium,
        bodyLarge: WellnessTypography.bodyLarge,
        bodyMedium: WellnessTypography.bodyMedium,
        labelLarge: WellnessTypography.labelLarge,
        labelMedium: WellnessTypography.labelMedium,
      ).apply(
        bodyColor: WellnessColors.textPrimary,
        displayColor: WellnessColors.textPrimary,
      ),

      // App Bar - Clean, elevated, branded
      appBarTheme: const AppBarTheme(
        backgroundColor: WellnessColors.backgroundPrimary,
        foregroundColor: WellnessColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: WellnessTypography.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Cards - Soft, elevated, welcoming
      cardTheme: CardTheme(
        color: WellnessColors.surfaceElevated,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
        ),
        margin: const EdgeInsets.all(WellnessSpacing.sm),
      ),

      // Elevated Button - Primary actions, confident
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WellnessColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: WellnessSpacing.lg,
            vertical: WellnessSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
          ),
          textStyle: WellnessTypography.labelLarge,
        ),
      ),

      // Outlined Button - Secondary actions, subtle
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WellnessColors.primaryGreen,
          side: const BorderSide(color: WellnessColors.primaryGreen),
          padding: const EdgeInsets.symmetric(
            horizontal: WellnessSpacing.lg,
            vertical: WellnessSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
          ),
          textStyle: WellnessTypography.labelLarge,
        ),
      ),

      // Text Button - Tertiary actions, minimal
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WellnessColors.secondaryBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: WellnessSpacing.md,
            vertical: WellnessSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WellnessBorderRadius.sm),
          ),
          textStyle: WellnessTypography.labelMedium,
        ),
      ),

      // Floating Action Button - Primary CTA, prominent
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: WellnessColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Input Decoration - Forms, friendly and clear
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WellnessColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
          borderSide: const BorderSide(
            color: WellnessColors.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
          borderSide: const BorderSide(
            color: WellnessColors.primaryGreen,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: WellnessSpacing.md,
          vertical: WellnessSpacing.md,
        ),
        hintStyle: WellnessTypography.bodyMedium.copyWith(
          color: WellnessColors.textTertiary,
        ),
        labelStyle: WellnessTypography.labelMedium.copyWith(
          color: WellnessColors.textSecondary,
        ),
      ),

      // List Tile - Information display, organized
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: WellnessSpacing.md,
          vertical: WellnessSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(WellnessBorderRadius.sm),
          ),
        ),
      ),

      // Chip - Tags, categories, selections
      chipTheme: ChipThemeData(
        backgroundColor: WellnessColors.backgroundSecondary,
        selectedColor: WellnessColors.primaryGreen.withOpacity(0.2),
        disabledColor: WellnessColors.backgroundTertiary,
        labelStyle: WellnessTypography.labelMedium,
        secondaryLabelStyle: WellnessTypography.labelMedium.copyWith(
          color: WellnessColors.primaryGreen,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: WellnessSpacing.sm,
          vertical: WellnessSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.circular),
        ),
      ),

      // Switch - Toggle controls, clear states
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return WellnessColors.primaryGreen;
          }
          return WellnessColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return WellnessColors.primaryGreen.withOpacity(0.3);
          }
          return WellnessColors.backgroundTertiary;
        }),
      ),

      // Slider - Progress controls, smooth interaction
      sliderTheme: const SliderThemeData(
        activeTrackColor: WellnessColors.primaryGreen,
        inactiveTrackColor: WellnessColors.backgroundTertiary,
        thumbColor: WellnessColors.primaryGreen,
        overlayColor: Color.fromRGBO(126, 217, 87, 0.2),
        valueIndicatorColor: WellnessColors.primaryGreen,
        valueIndicatorTextStyle: WellnessTypography.labelMedium,
      ),

      // Progress Indicator - Loading states, encouraging
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: WellnessColors.primaryGreen,
        linearTrackColor: WellnessColors.backgroundTertiary,
        circularTrackColor: WellnessColors.backgroundTertiary,
      ),

      // Divider - Subtle separations
      dividerTheme: const DividerThemeData(
        color: WellnessColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation - Main navigation, accessible
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: WellnessColors.backgroundPrimary,
        selectedItemColor: WellnessColors.primaryGreen,
        unselectedItemColor: WellnessColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: WellnessTypography.labelMedium,
        unselectedLabelStyle: WellnessTypography.labelMedium,
      ),

      // Icon Theme - Consistent, friendly
      iconTheme: const IconThemeData(
        color: WellnessColors.textSecondary,
        size: 24,
      ),

      // Primary Icon Theme - Branded, prominent
      primaryIconTheme: const IconThemeData(
        color: WellnessColors.primaryGreen,
        size: 24,
      ),
    );
  }

  /// Get themed gradient for containers and backgrounds
  static LinearGradient getWellnessGradient({
    Color? startColor,
    Color? endColor,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        startColor ?? WellnessColors.primaryGreen.withOpacity(0.1),
        endColor ?? WellnessColors.secondaryBlue.withOpacity(0.1),
      ],
    );
  }

  /// Get motivational colors for different states
  static Color getMotivationalColor(String state) {
    switch (state.toLowerCase()) {
      case 'excellent':
      case 'achieved':
        return WellnessColors.successGreen;
      case 'good':
      case 'progress':
        return WellnessColors.primaryGreen;
      case 'okay':
      case 'partial':
        return WellnessColors.sunsetOrange;
      case 'needs_work':
      case 'warning':
        return WellnessColors.warningAmber;
      default:
        return WellnessColors.secondaryBlue;
    }
  }
}
