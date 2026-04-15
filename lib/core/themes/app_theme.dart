import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  // static final theme = ThemeData(
  //   textTheme: const TextTheme(
  //       headlineLarge: TextStyle(
  //         color: AppColor.primary,
  //         fontSize: 25,
  //       ),
  //       titleMedium: TextStyle(
  //         fontSize: 20,
  //       ),
  //       bodySmall: TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.bold,
  //       )
  //     ),
  // inputDecorationTheme: InputDecorationTheme(
  //   errorStyle: const TextStyle(
  //     fontSize: 12,
  //     color: Colors.red,
  //     fontWeight: FontWeight.normal,
  //   ),
  //   filled: true,
  //   fillColor: AppColor.placeholderBg,
  //   contentPadding: const EdgeInsets.symmetric(
  //     horizontal: 30,
  //   ),
  //   hintStyle: const TextStyle(
  //     color: AppColor.placeholder,
  //     fontWeight: FontWeight.normal,
  //   ),
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(30),
  //     borderSide: BorderSide.none,
  //   ),
  // ),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: AppColor.green,
  //       foregroundColor: Colors.white,
  //       elevation: 0,
  //       shape: const StadiumBorder(),
  //     ),
  //   ),
  // );
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xFF0040E0),
        onPrimary: const Color(0xFFFFFFFF),
        primaryContainer: const Color(0xFF2E5BFF),
        onPrimaryContainer: const Color(0xFFEFEFFF),
        secondary: const Color(0xFF5F5E5E),
        onSecondary: const Color(0xFFFFFFFF),
        secondaryContainer: const Color(0xFFE5E2E1),
        onSecondaryContainer: const Color(0xFF656464),
        tertiary: const Color(0xFFAC061B),
        onTertiary: const Color(0xFFFFFFFF),
        tertiaryContainer: const Color(0xFFD02A30),
        onTertiaryContainer: const Color(0xFFFFECEA),
        error: const Color(0xFFBA1A1A),
        onError: const Color(0xFFFFFFFF),
        errorContainer: const Color(0xFFFFDAD6),
        onErrorContainer: const Color(0xFF93000A),
        surface: const Color(0xFFFCF9F8),
        onSurface: const Color(0xFF1C1B1B),
        surfaceContainerHighest: const Color(0xFFE5E2E1),
        surfaceContainerHigh: const Color(0xFFEAE7E7),
        surfaceContainer: const Color(0xFFF0EDED),
        surfaceContainerLow: const Color(0xFFF6F3F2),
        surfaceContainerLowest: const Color(0xFFFFFFFF),
        outline: const Color(0xFF747688),
        outlineVariant: const Color(0xFFC4C5D9),
      ),
      scaffoldBackgroundColor: const Color(0xFFFCF9F8),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C1B1B),
        ),
        displayMedium: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C1B1B),
        ),
        displaySmall: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C1B1B),
        ),
        headlineLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C1B1B),
        ),
        headlineMedium: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1C1B1B),
        ),
        headlineSmall: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1C1B1B),
        ),
        titleLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1C1B1B),
        ),
        titleMedium: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1C1B1B),
        ),
        titleSmall: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1C1B1B),
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1C1B1B),
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1C1B1B),
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.normal,
          color: const Color(0xFF5F5E5E),
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1C1B1B),
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1C1B1B),
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1C1B1B),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: const Color(0xFFF0EDED),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        hintStyle: const TextStyle(
          color: AppColor.placeholder,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0040E0),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
