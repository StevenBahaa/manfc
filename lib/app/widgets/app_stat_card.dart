import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppStatCardTone { neutral, blue, green, orange, red }

class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final AppStatCardTone tone;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool compact;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.tone = AppStatCardTone.neutral,
    this.onTap,
    this.margin,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final toneStyle = _resolveTone(palette);

    final card = Container(
      margin: margin,
      padding: EdgeInsets.all(compact ? 14 : AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: toneStyle.background,
        borderRadius: AppRadius.card,
        border: Border.all(color: toneStyle.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: toneStyle.iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: toneStyle.iconColor),
            ),
          if (icon != null) const SizedBox(height: 14),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyles.footnote.copyWith(
              color: palette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: compact ? textStyles.amountMedium : textStyles.amountLarge,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyles.footnote.copyWith(color: palette.textSecondary),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: AppRadius.card, child: card),
    );
  }

  _StatCardToneStyle _resolveTone(AppColorPalette palette) {
    switch (tone) {
      case AppStatCardTone.neutral:
        return _StatCardToneStyle(
          background: palette.surface,
          border: palette.border,
          iconBackground: palette.surfaceSecondary,
          iconColor: palette.iconSecondary,
        );

      case AppStatCardTone.blue:
        return _StatCardToneStyle(
          background: palette.cardBlueSoft,
          border: palette.border,
          iconBackground: palette.cardBlue,
          iconColor: palette.textOnPrimary,
        );

      case AppStatCardTone.green:
        return _StatCardToneStyle(
          background: palette.cardGreenSoft,
          border: palette.border,
          iconBackground: palette.success,
          iconColor: palette.textOnPrimary,
        );

      case AppStatCardTone.orange:
        return _StatCardToneStyle(
          background: palette.cardOrangeSoft,
          border: palette.border,
          iconBackground: palette.warning,
          iconColor: palette.textOnPrimary,
        );

      case AppStatCardTone.red:
        return _StatCardToneStyle(
          background: palette.cardRedSoft,
          border: palette.border,
          iconBackground: palette.danger,
          iconColor: palette.textOnPrimary,
        );
    }
  }
}

class _StatCardToneStyle {
  final Color background;
  final Color border;
  final Color iconBackground;
  final Color iconColor;

  const _StatCardToneStyle({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.iconColor,
  });
}
