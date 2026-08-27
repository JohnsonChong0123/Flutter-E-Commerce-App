import 'package:flutter/material.dart';

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
        displayLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1C1B1B),
        ),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1C1B1B),
        ),
        displaySmall: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1C1B1B),
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1C1B1B),
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C1B1B),
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C1B1B),
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1B1B),
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1B1B),
        ),
        titleSmall: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1B1B),
        ),
        bodyLarge: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Color(0xFF1C1B1B),
        ),
        bodyMedium: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Color(0xFF1C1B1B),
        ),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Color(0xFF5F5E5E),
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1B1B),
        ),
        labelMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1B1B),
        ),
        labelSmall: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1B1B),
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
