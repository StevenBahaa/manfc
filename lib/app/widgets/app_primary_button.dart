import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool expand;
  final double height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
    this.height = 52,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.borderRadius,
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

    final _ButtonStyle style = _resolveStyle(palette);

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: height,
      width: expand ? double.infinity : null,
      padding: padding,
      decoration: BoxDecoration(
        color: onPressed == null || isLoading
            ? palette.disabled
            : style.backgroundColor,
        borderRadius: borderRadius ?? AppRadius.button,
        border: style.borderColor != null
            ? Border.all(color: style.borderColor!, width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (onPressed == null || isLoading) ? null : onPressed,
          borderRadius: borderRadius ?? AppRadius.button,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          style.foregroundColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: expand
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (prefixIcon != null) ...[
                          IconTheme(
                            data: IconThemeData(
                              color: style.foregroundColor,
                              size: 18,
                            ),
                            child: prefixIcon!,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyles.button.copyWith(
                              color: style.foregroundColor,
                            ),
                          ),
                        ),
                        if (suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          IconTheme(
                            data: IconThemeData(
                              color: style.foregroundColor,
                              size: 18,
                            ),
                            child: suffixIcon!,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    return expand ? button : IntrinsicWidth(child: button);
  }

  _ButtonStyle _resolveStyle(AppColorPalette palette) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: palette.primary,
          foregroundColor: palette.textOnPrimary,
        );

      case AppButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: palette.surface,
          foregroundColor: palette.textPrimary,
          borderColor: palette.border,
        );

      case AppButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: palette.surfaceSecondary,
          foregroundColor: palette.primary,
        );

      case AppButtonVariant.danger:
        return _ButtonStyle(
          backgroundColor: palette.danger,
          foregroundColor: palette.textOnPrimary,
        );
    }
  }
}

class _ButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}
