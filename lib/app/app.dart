import 'package:flutter/material.dart';
import 'package:manfc/app/controllers/app_settings_controller.dart';
import 'package:manfc/app/navigation/main_shell.dart';
import 'package:manfc/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  final AppSettingsController appSettingsController;

  const MyApp({super.key, required this.appSettingsController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettingsController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Factory Sales App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appSettingsController.themeMode,
          locale: appSettingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MainShell(appSettingsController: appSettingsController),
        );
      },
    );
  }
}
