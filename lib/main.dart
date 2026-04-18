import 'package:flutter/material.dart';
import 'package:manfc/app/controllers/app_settings_controller.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appSettingsController = AppSettingsController();
  await appSettingsController.load();

  runApp(MyApp(appSettingsController: appSettingsController));
}