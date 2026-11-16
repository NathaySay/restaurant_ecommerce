import 'package:material_ui/material_ui.dart';

/// Warm, appetizing palette for the Balancika Demo brand.
abstract final class AppColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color terracotta = Color(0xFFE85D2C);
  static const Color terracottaDeep = Color(0xFFC74A1E);
  static const Color coffee = Color(0xFF2D1B12);
  static const Color taupe = Color(0xFF7A6A5F);
  static const Color inkSoft = Color(0xFF5F5046);
  static const Color sand = Color(0xFFF5E7D8);
  static const Color honey = Color(0xFFF2A65A);
  static const Color gold = Color(0xFFE9A23B);
  static const Color leaf = Color(0xFF3F7D4E);
  static const Color stroke = Color(0xFFEFE1D3);
}

abstract final class AppTheme {
  static const String _font = 'Poppins';

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.terracotta)
        .copyWith(
          primary: AppColors.terracotta,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFDE1D4),
          onPrimaryContainer: const Color(0xFF5E1F08),
          secondary: AppColors.honey,
          onSecondary: AppColors.coffee,
          secondaryContainer: AppColors.sand,
          onSecondaryContainer: AppColors.coffee,
          surface: AppColors.surface,
          onSurface: AppColors.coffee,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppColors.cream,
          surfaceContainer: const Color(0xFFFFF3E7),
          surfaceContainerHigh: const Color(0xFFF9ECDD),
          surfaceContainerHighest: const Color(0xFFF3E2D1),
          outline: AppColors.taupe,
          outlineVariant: AppColors.stroke,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _font,
      scaffoldBackgroundColor: AppColors.cream,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: AppColors.coffee,
          height: 1.15,
          letterSpacing: -0.6,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.coffee,
          height: 1.2,
          letterSpacing: -0.4,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
          height: 1.25,
        ),
        titleLarge: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        titleSmall: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        bodyLarge: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.coffee,
          height: 1.55,
        ),
        bodyMedium: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: AppColors.coffee,
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.taupe,
          height: 1.45,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.taupe,
        ),
        labelSmall: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: AppColors.taupe,
          letterSpacing: 0.6,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.coffee,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _font,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.stroke,
          disabledForegroundColor: AppColors.taupe,
          minimumSize: const Size(0, 54),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: _font,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.terracottaDeep,
          textStyle: const TextStyle(
            fontFamily: _font,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.coffee,
        actionTextColor: AppColors.honey,
        behavior: SnackBarBehavior.floating,
        elevation: 3,
        insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        contentTextStyle: const TextStyle(
          fontFamily: _font,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.stroke,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.terracotta,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFFFDE1D4),
        height: 72,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: _font,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.terracottaDeep : AppColors.taupe,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? AppColors.terracottaDeep : AppColors.taupe,
          );
        }),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.terracotta,
        textColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: _font,
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.terracotta,
        selectionColor: Color(0x33E85D2C),
        selectionHandleColor: AppColors.terracotta,
      ),
    );
  }
}
