import 'package:flutter/material.dart';
import 'package:amazon_clone_admin/core/models/admin_user.dart';

class AppColors {
  static const Color primary = Color(0xFF00F7FF);
  static const Color onPrimary = Colors.black;
  static const Color secondary = Color(0xFFFF00FF);
  static const Color tertiary = Color(0xFFCCFF00);
  static const Color surface = Color(0xFF1F1F1F);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF5252);
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white54,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

class AppButtonStyles {
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: Colors.white, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class AppInputDecorations {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    hintStyle: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
  );
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      titleLarge: AppTextStyles.titleLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    elevatedButtonTheme: AppButtonStyles.elevatedButtonTheme,
    outlinedButtonTheme: AppButtonStyles.outlinedButtonTheme,
    inputDecorationTheme: AppInputDecorations.inputDecorationTheme,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.background,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.black),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.black),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.black),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.black),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.black),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 24,
    ),
    elevatedButtonTheme: AppButtonStyles.elevatedButtonTheme,
    outlinedButtonTheme: AppButtonStyles.outlinedButtonTheme,
    inputDecorationTheme: AppInputDecorations.inputDecorationTheme.copyWith(
      labelStyle: AppInputDecorations.inputDecorationTheme.labelStyle!.copyWith(color: Colors.black87),
      hintStyle: AppInputDecorations.inputDecorationTheme.hintStyle!.copyWith(color: Colors.black54),
    ),
  );

  static ThemeData getThemeData(AdminUser adminUser) {
    return adminUser.themePreference == 'dark' ? darkTheme : lightTheme;
  }
}
