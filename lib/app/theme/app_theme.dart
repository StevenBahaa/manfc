import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(
        palette: AppColors.light,
        brightness: Brightness.light,
      );

  static ThemeData dark() => _buildTheme(
        palette: AppColors.dark,
        brightness: Brightness.dark,
      );

  static ThemeData _buildTheme({
    required AppColorPalette palette,
    required Brightness brightness,
  }) {
    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        onPrimary: palette.textOnPrimary,
        secondary: palette.primary,
        onSecondary: palette.textOnPrimary,
        error: palette.danger,
        onError: palette.textOnPrimary,
        surface: palette.surface,
        onSurface: palette.textPrimary,
      ),
    );

    return base.copyWith(
      splashFactory: NoSplash.splashFactory,
      canvasColor: palette.background,
      dividerColor: palette.divider,

      textTheme: TextTheme(
        displayLarge: textStyles.largeTitle,
        displayMedium: textStyles.title1,
        displaySmall: textStyles.title2,
        headlineMedium: textStyles.title3,
        headlineSmall: textStyles.headline,
        bodyLarge: textStyles.body,
        bodyMedium: textStyles.subhead,
        bodySmall: textStyles.footnote,
        labelLarge: textStyles.button,
        labelMedium: textStyles.caption,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        centerTitle: false,
        titleTextStyle: textStyles.title3,
      ),

      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: palette.border,
            width: 0.8,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: textStyles.body.copyWith(
          color: palette.textTertiary,
        ),
        labelStyle: textStyles.subhead,
        floatingLabelStyle: textStyles.subhead.copyWith(
          color: palette.primary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: palette.inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: palette.primary,
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: palette.danger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: palette.danger,
            width: 1.2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(
            color: palette.border,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: palette.primary,
          foregroundColor: palette.textOnPrimary,
          disabledBackgroundColor: palette.disabled,
          disabledForegroundColor: palette.surface,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: textStyles.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: palette.textPrimary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(
            color: palette.border,
            width: 1,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: textStyles.bodyMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: textStyles.bodyMedium,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.sheet,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: textStyles.title3,
        contentTextStyle: textStyles.body,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: palette.iconSecondary,
        textColor: palette.textPrimary,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceSecondary,
        disabledColor: palette.disabled,
        selectedColor: palette.primaryLight,
        secondarySelectedColor: palette.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        side: BorderSide(color: palette.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        labelStyle: textStyles.footnote.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: textStyles.footnote.copyWith(
          color: palette.primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      iconTheme: IconThemeData(
        color: palette.iconPrimary,
        size: 22,
      ),

      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: palette.primary,
        scaffoldBackgroundColor: palette.background,
        barBackgroundColor: palette.background,
        textTheme: CupertinoTextThemeData(
          primaryColor: palette.primary,
          navTitleTextStyle: textStyles.headline,
          navLargeTitleTextStyle: textStyles.largeTitle,
          textStyle: textStyles.body,
        ),
      ),
    );
  }
}