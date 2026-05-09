import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'db_provider.g.dart';

@Riverpod(keepAlive: true)
Database db(Ref ref) {
  throw UnimplementedError('dbProvider must be overridden in ProviderScope');
}
