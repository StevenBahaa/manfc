import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/db_tables.dart';
import '../models/payment_model.dart';

class PaymentLocalDataSource {
  PaymentLocalDataSource._();

  static final PaymentLocalDataSource instance = PaymentLocalDataSource._();

  Future<Database> get _db async => AppDatabase.instance.database;

  Future<void> insertPayment(PaymentModel payment) async {
    final db = await _db;
    await db.insert(
      DbTables.payments,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PaymentModel>> getPaymentsByInvoiceId(String invoiceId) async {
    final db = await _db;
    final maps = await db.query(
      DbTables.payments,
      where: '${PaymentTableColumns.invoiceId} = ?',
      whereArgs: [invoiceId],
      orderBy: '${PaymentTableColumns.paymentDate} DESC',
    );

    return maps.map(PaymentModel.fromMap).toList();
  }

  Future<List<PaymentModel>> getPaymentsByCustomerId(String customerId) async {
    final db = await _db;
    final maps = await db.query(
      DbTables.payments,
      where: '${PaymentTableColumns.customerId} = ?',
      whereArgs: [customerId],
      orderBy: '${PaymentTableColumns.paymentDate} DESC',
    );

    return maps.map(PaymentModel.fromMap).toList();
  }

  Future<double> getTotalPaidForInvoice(String invoiceId) async {
    final db = await _db;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(${PaymentTableColumns.amount}), 0) AS total_paid
      FROM ${DbTables.payments}
      WHERE ${PaymentTableColumns.invoiceId} = ?
      ''',
      [invoiceId],
    );

    final value = result.first['total_paid'];
    if (value == null) return 0;
    return (value as num).toDouble();
  }

  Future<List<PaymentModel>> getAllPayments() async {
    final db = await _db;

    final maps = await db.query(
      DbTables.payments,
      orderBy: '${PaymentTableColumns.paymentDate} DESC',
    );

    return maps.map(PaymentModel.fromMap).toList();
  }
}
