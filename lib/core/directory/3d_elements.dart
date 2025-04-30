import 'package:flutter/material.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';

class App3DElements {
  static const Map<int, BoxShadow> elevations = {
    0: BoxShadow(color: Colors.transparent),
    1: BoxShadow(color: AppColors.surface, blurRadius: 2, offset: Offset(2, 2)),
    2: BoxShadow(color: AppColors.surface, blurRadius: 4, offset: Offset(2, 2)),
    3: BoxShadow(color: AppColors.surface, blurRadius: 6, offset: Offset(2, 2)),
    4: BoxShadow(color: AppColors.surface, blurRadius: 8, offset: Offset(2, 2)),
  };

  static BoxDecoration elevatedContainer({
    required double elevation,
    required Color backgroundColor,
    required BorderRadius borderRadius,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      boxShadow: [elevations[elevation.toInt()]!],
    );
  }

  static Widget layeredCard({
    required Widget child,
    required double elevation,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: elevatedContainer(
        elevation: elevation,
        backgroundColor: isDarkMode ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  static Widget raisedButton({
    required Widget child,
    required VoidCallback onPressed,
    required double elevation,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: elevatedContainer(
          elevation: elevation,
          backgroundColor: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: isDarkMode ? AppColors.onPrimary : AppColors.surface,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  static Widget floatingCard({
    required Widget child,
    double elevation = 4.0,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: elevatedContainer(
        elevation: elevation,
        backgroundColor: isDarkMode ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}
