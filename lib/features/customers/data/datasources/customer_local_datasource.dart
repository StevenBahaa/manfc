import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/db_tables.dart';
import '../models/customer_model.dart';

class CustomerLocalDataSource {
  CustomerLocalDataSource();

  Future<List<CustomerModel>> getAllCustomers() async {
    final Database db = await AppDatabase.instance.database;

    final result = await db.query(
      DbTables.customers,
      orderBy: '${CustomerTableColumns.createdAt} DESC',
    );

    return result.map(CustomerModel.fromMap).toList();
  }

  Future<void> insertCustomer(CustomerModel customer) async {
    final Database db = await AppDatabase.instance.database;

    await db.insert(
      DbTables.customers,
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    final Database db = await AppDatabase.instance.database;

    await db.update(
      DbTables.customers,
      customer.toMap(),
      where: '${CustomerTableColumns.id} = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> deleteCustomer(String customerId) async {
    final Database db = await AppDatabase.instance.database;

    await db.delete(
      DbTables.customers,
      where: '${CustomerTableColumns.id} = ?',
      whereArgs: [customerId],
    );
  }
}
