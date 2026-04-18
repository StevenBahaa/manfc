import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class AppColorPalette {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  final Color background;
  final Color surface;
  final Color surfaceSecondary;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;

  final Color border;
  final Color divider;
  final Color shadow;

  final Color success;
  final Color warning;
  final Color danger;

  final Color unpaid;
  final Color partial;
  final Color paid;

  final Color iconPrimary;
  final Color iconSecondary;

  final Color disabled;
  final Color inputFill;
  final Color inputBorder;

  final Color cardBlue;
  final Color cardBlueSoft;
  final Color cardGreenSoft;
  final Color cardOrangeSoft;
  final Color cardRedSoft;

  const AppColorPalette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.success,
    required this.warning,
    required this.danger,
    required this.unpaid,
    required this.partial,
    required this.paid,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.disabled,
    required this.inputFill,
    required this.inputBorder,
    required this.cardBlue,
    required this.cardBlueSoft,
    required this.cardGreenSoft,
    required this.cardOrangeSoft,
    required this.cardRedSoft,
  });
}

abstract final class AppColors {
  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFF007AFF),
    primaryDark: Color(0xFF005ECF),
    primaryLight: Color(0xFFEAF3FF),

    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF1F3F5),

    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    textOnPrimary: Color(0xFFFFFFFF),

    border: Color(0xFFE5E7EB),
    divider: Color(0xFFEEF0F2),
    shadow: Color(0x0D000000),

    success: Color(0xFF34C759),
    warning: Color(0xFFFF9F0A),
    danger: Color(0xFFFF3B30),

    unpaid: Color(0xFFFF3B30),
    partial: Color(0xFFFF9F0A),
    paid: Color(0xFF34C759),

    iconPrimary: Color(0xFF111827),
    iconSecondary: Color(0xFF6B7280),

    disabled: Color(0xFFC7CDD4),
    inputFill: Color(0xFFFFFFFF),
    inputBorder: Color(0xFFE5E7EB),

    cardBlue: Color(0xFF0A84FF),
    cardBlueSoft: Color(0xFFEAF4FF),
    cardGreenSoft: Color(0xFFEAF9EF),
    cardOrangeSoft: Color(0xFFFFF4E5),
    cardRedSoft: Color(0xFFFFECEA),
  );

  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFF0A84FF),
    primaryDark: Color(0xFF409CFF),
    primaryLight: Color(0xFF10304F),

    background: Color(0xFF0F1115),
    surface: Color(0xFF171A20),
    surfaceSecondary: Color(0xFF1E222A),

    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFFB6BDC7),
    textTertiary: Color(0xFF8E97A3),
    textOnPrimary: Color(0xFFFFFFFF),

    border: Color(0xFF2B313B),
    divider: Color(0xFF232932),
    shadow: Color(0x1A000000),

    success: Color(0xFF30D158),
    warning: Color(0xFFFF9F0A),
    danger: Color(0xFFFF453A),

    unpaid: Color(0xFFFF453A),
    partial: Color(0xFFFF9F0A),
    paid: Color(0xFF30D158),

    iconPrimary: Color(0xFFF3F4F6),
    iconSecondary: Color(0xFFB6BDC7),

    disabled: Color(0xFF4B5563),
    inputFill: Color(0xFF1C2027),
    inputBorder: Color(0xFF313845),

    cardBlue: Color(0xFF0A84FF),
    cardBlueSoft: Color(0xFF10253D),
    cardGreenSoft: Color(0xFF11271A),
    cardOrangeSoft: Color(0xFF332510),
    cardRedSoft: Color(0xFF331816),
  );

  static CupertinoDynamicColor dynamic({
    required Color lightColor,
    required Color darkColor,
  }) {
    return CupertinoDynamicColor.withBrightness(
      color: lightColor,
      darkColor: darkColor,
    );
  }
}
