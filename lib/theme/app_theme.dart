import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AppTheme {
  // Light theme colors
  static const _lightPrimary = Color(0xFF2563EB); // Blue
  static const _lightSecondary = Color(0xFF7C3AED); // Purple
  static const _lightBackground = Color(0xFFF8FAFC);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightTextPrimary = Color(0xFF0F172A);
  static const _lightTextSecondary = Color(0xFF64748B);
  static const _lightDivider = Color(0xFFE2E8F0);
  static const _lightAccent = Color(0xFF10B981); // Green

  // Dark theme colors
  static const _darkPrimary = Color(0xFF3B82F6); // Lighter Blue
  static const _darkSecondary = Color(0xFF8B5CF6); // Lighter Purple
  static const _darkBackground = Color(0xFF0F172A);
  static const _darkSurface = Color(0xFF1E293B);
  static const _darkTextPrimary = Color(0xFFF1F5F9);
  static const _darkTextSecondary = Color(0xFF94A3B8);
  static const _darkDivider = Color(0xFF334155);
  static const _darkAccent = Color(0xFF34D399); // Lighter Green

  // Create light theme
  static MacosThemeData lightTheme() {
    return MacosThemeData.light().copyWith(
      primaryColor: _lightPrimary,
      canvasColor: _lightBackground,
      dividerColor: _lightDivider,
      typography: MacosTypography(
        color: _lightTextPrimary,
        largeTitle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: _lightTextPrimary,
          letterSpacing: -0.5,
        ),
        title1: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
          letterSpacing: -0.3,
        ),
        title2: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
          letterSpacing: -0.2,
        ),
        title3: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        headline: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        body: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _lightTextPrimary,
        ),
        callout: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: _lightTextSecondary,
        ),
        subheadline: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: _lightTextSecondary,
        ),
        footnote: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: _lightTextSecondary,
        ),
        caption1: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: _lightTextSecondary,
        ),
        caption2: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: _lightTextSecondary,
        ),
      ),
      pushButtonTheme: PushButtonThemeData(
        color: _lightPrimary,
        secondaryColor: _lightSurface,
      ),
    );
  }

  // Create dark theme
  static MacosThemeData darkTheme() {
    return MacosThemeData.dark().copyWith(
      primaryColor: _darkPrimary,
      canvasColor: _darkBackground,
      dividerColor: _darkDivider,
      typography: MacosTypography(
        color: _darkTextPrimary,
        largeTitle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: _darkTextPrimary,
          letterSpacing: -0.5,
        ),
        title1: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
          letterSpacing: -0.3,
        ),
        title2: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
          letterSpacing: -0.2,
        ),
        title3: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        headline: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        body: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _darkTextPrimary,
        ),
        callout: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: _darkTextSecondary,
        ),
        subheadline: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: _darkTextSecondary,
        ),
        footnote: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: _darkTextSecondary,
        ),
        caption1: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: _darkTextSecondary,
        ),
        caption2: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: _darkTextSecondary,
        ),
      ),
      pushButtonTheme: PushButtonThemeData(
        color: _darkPrimary,
        secondaryColor: _darkSurface,
      ),
    );
  }

  // Surface colors for containers
  static Color surfaceColor(BuildContext context) {
    final brightness = MacosTheme.of(context).brightness;
    return brightness == Brightness.dark ? _darkSurface : _lightSurface;
  }

  // Accent colors
  static Color accentColor(BuildContext context) {
    final brightness = MacosTheme.of(context).brightness;
    return brightness == Brightness.dark ? _darkAccent : _lightAccent;
  }

  // Gradient backgrounds
  static LinearGradient primaryGradient(BuildContext context) {
    final brightness = MacosTheme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_darkPrimary, _darkSecondary],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_lightPrimary, _lightSecondary],
      );
    }
  }

  // Card decoration
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: surfaceColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: MacosTheme.of(context).dividerColor,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Elevated card decoration
  static BoxDecoration elevatedCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: surfaceColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: MacosTheme.of(context).dividerColor,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
