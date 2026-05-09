import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manfc/core/database/app_database.dart';
import 'package:manfc/app/providers/db_provider.dart';
import 'package:manfc/app/providers/shared_prefs_provider.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize new providers
  final sharedPrefs = await SharedPreferences.getInstance();
  final database = await AppDatabase.instance.database;

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPrefs),
        dbProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}