import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/settings_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../widgets/settings_option_tile.dart';
import 'package:manfc/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => AppScaffold(
        title: l10n.settingsTitle,
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
                l10n.settingsSubtitle,
                style: textStyles.body.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.settingsAppearance,
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
                      title: l10n.settingsLightMode,
                      subtitle: l10n.settingsLightModeDesc,
                      isSelected: settings.themeMode == ThemeMode.light,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setThemeMode(ThemeMode.light),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsOptionTile(
                      title: l10n.settingsDarkMode,
                      subtitle: l10n.settingsDarkModeDesc,
                      isSelected: settings.themeMode == ThemeMode.dark,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setThemeMode(ThemeMode.dark),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsOptionTile(
                      title: l10n.settingsSystemMode,
                      subtitle: l10n.settingsSystemModeDesc,
                      isSelected: settings.themeMode == ThemeMode.system,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.settingsLanguage, style: textStyles.title3),
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
                      title: l10n.settingsLanguageEnglish,
                      subtitle: l10n.settingsLanguageEnglishDesc,
                      isSelected: settings.locale.languageCode == 'en',
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setLocale(const Locale('en')),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsOptionTile(
                      title: l10n.settingsLanguageArabic,
                      subtitle: l10n.settingsLanguageArabicDesc,
                      isSelected: settings.locale.languageCode == 'ar',
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setLocale(const Locale('ar')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => AppScaffold(
        title: l10n.settingsTitle,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => AppScaffold(
        title: l10n.settingsTitle,
        child: Center(child: Text('Error: $err')),
      ),
    );
  }
}
