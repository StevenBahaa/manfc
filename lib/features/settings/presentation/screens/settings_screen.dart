import 'package:flutter/material.dart';

import '../../../../app/controllers/app_settings_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../widgets/settings_option_tile.dart';

class SettingsScreen extends StatelessWidget {
  final AppSettingsController controller;

  const SettingsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final isArabic = controller.locale.languageCode == 'ar';

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AppScaffold(
          title: isArabic ? 'الإعدادات' : 'Settings',
          useLargeTitle: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.cardPadding,
              right: AppSpacing.cardPadding,
              top: AppSpacing.lg,
              bottom: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? 'خصص مظهر التطبيق واللغة'
                      : 'Customize your app appearance and language',
                  style: textStyles.body.copyWith(color: palette.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  isArabic ? 'المظهر' : 'Appearance',
                  style: textStyles.title3,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    children: [
                      SettingsOptionTile(
                        title: isArabic ? 'فاتح' : 'Light',
                        subtitle: isArabic
                            ? 'تشغيل الوضع الفاتح دائمًا'
                            : 'Always use light mode',
                        isSelected: controller.themeMode == ThemeMode.light,
                        onTap: () => controller.setThemeMode(ThemeMode.light),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SettingsOptionTile(
                        title: isArabic ? 'داكن' : 'Dark',
                        subtitle: isArabic
                            ? 'تشغيل الوضع الداكن دائمًا'
                            : 'Always use dark mode',
                        isSelected: controller.themeMode == ThemeMode.dark,
                        onTap: () => controller.setThemeMode(ThemeMode.dark),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SettingsOptionTile(
                        title: isArabic ? 'حسب الجهاز' : 'System',
                        subtitle: isArabic
                            ? 'اتبع إعدادات الجهاز'
                            : 'Follow device settings',
                        isSelected: controller.themeMode == ThemeMode.system,
                        onTap: () => controller.setThemeMode(ThemeMode.system),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(isArabic ? 'اللغة' : 'Language', style: textStyles.title3),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    children: [
                      SettingsOptionTile(
                        title: 'English',
                        subtitle: 'App language in English',
                        isSelected: controller.locale.languageCode == 'en',
                        onTap: () => controller.setLocale(const Locale('en')),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SettingsOptionTile(
                        title: 'العربية',
                        subtitle: 'لغة التطبيق بالعربية',
                        isSelected: controller.locale.languageCode == 'ar',
                        onTap: () => controller.setLocale(const Locale('ar')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
