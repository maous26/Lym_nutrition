import 'package:flutter/material.dart';

/// Modern, wellness-focused color palette for exceptional UX
/// Inspired by top nutrition apps (Lifesum, Yazio, Fabulous)
class WellnessColors {
  // Primary Brand Colors - Soft, friendly, health-focused
  static const Color primaryGreen = Color(0xFF7ED957); // Vibrant yet soft green
  static const Color secondaryBlue = Color(0xFF6EC1E4); // Calming sky blue
  static const Color accentPeach = Color(0xFFFFBFAE); // Warm, welcoming peach
  static const Color neutralCream = Color(0xFFF9F9F9); // Off-white background

  // Extended Palette for variety and personalization
  static const Color mintGreen = Color(0xFFA8E6CF); // Gentle mint
  static const Color lavenderBlue = Color(0xFFB8C6DB); // Soft lavender
  static const Color sunsetOrange =
      Color(0xFFFFD93D); // Motivating yellow-orange
  static const Color roseGold = Color(0xFFE8B4B8); // Elegant rose

  // Functional Colors - Accessible and clear
  static const Color successGreen = Color(0xFF4CAF50); // Achievement feedback
  static const Color warningAmber = Color(0xFFFF9800); // Gentle warnings
  static const Color errorCoral = Color(0xFFFF6B6B); // Friendly error states
  static const Color infoBlue = Color(0xFF2196F3); // Information highlights

  // Text & Content Colors - High contrast, readable
  static const Color textPrimary =
      Color(0xFF2D3748); // Dark charcoal for readability
  static const Color textSecondary =
      Color(0xFF718096); // Medium gray for subtitles
  static const Color textTertiary =
      Color(0xFFA0AEC0); // Light gray for captions

  // Additional Onboarding Colors
  static const Color lightMint = Color(0xFFE8F8F5); // Very light mint background
  static const Color charcoalGray = Color(0xFF2D3748); // Same as textPrimary for consistency
  static const Color softGray = Color(0xFFF1F5F9); // Soft gray for subtle backgrounds

  // Background Variations - Depth and hierarchy
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color backgroundSecondary = Color(0xFFF7FAFC); // Very light gray
  static const Color backgroundTertiary = Color(0xFFEDF2F7); // Light warm gray

  // Interactive States - Feedback and engagement
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Cards, modals
  static const Color surfacePressed = Color(0xFFE2E8F0); // Touch feedback
  static const Color divider = Color(0xFFE2E8F0); // Subtle separators

  /// Get color based on nutrition score (0.0 - 5.0)
  static Color getNutritionScoreColor(double score) {
    if (score >= 4.5) return successGreen;
    if (score >= 3.5) return primaryGreen;
    if (score >= 2.5) return sunsetOrange;
    if (score >= 1.5) return warningAmber;
    return errorCoral;
  }

  /// Get motivational gradient colors for progress indicators
  static List<Color> getProgressGradient(double progress) {
    if (progress >= 0.8) {
      return [successGreen.withOpacity(0.8), primaryGreen];
    } else if (progress >= 0.6) {
      return [primaryGreen.withOpacity(0.8), secondaryBlue];
    } else if (progress >= 0.4) {
      return [secondaryBlue.withOpacity(0.8), accentPeach];
    } else {
      return [accentPeach.withOpacity(0.8), roseGold];
    }
  }

  /// AI Assistant avatar colors - friendly and approachable
  static const List<Color> aiAvatarGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];

  /// Gamification badge colors - exciting and rewarding
  static const List<Color> badgeGradients = [
    Color(0xFFFFD93D), // Gold achievement
    Color(0xFF6EC1E4), // Silver progress
    Color(0xFFFFBFAE), // Bronze participation
    Color(0xFF7ED957), // Green health focus
  ];
}

/// Typography system - Rounded, friendly, accessible
class WellnessTypography {
  static const String primaryFont = 'Nunito'; // Rounded, friendly
  static const String displayFont = 'Quicksand'; // Headers, bold statements

  // Text Styles - Semantic and consistent
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.1,
  );
}

/// Spacing system - Consistent, harmonious
class WellnessSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius system - Soft, rounded, friendly
class WellnessBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double circular = 50.0; // For perfect circles
}

/// Shadow system - Depth and elevation
class WellnessShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> colored(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
