import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/db_tables.dart';
import '../models/invoice_item_model.dart';
import '../models/invoice_model.dart';

class InvoiceLocalDataSource {
  InvoiceLocalDataSource();

  Future<List<InvoiceModel>> getAllInvoices() async {
    final db = await AppDatabase.instance.database;

    final invoices = await db.query(
      DbTables.invoices,
      orderBy: '${InvoiceTableColumns.createdAt} DESC',
    );

    final List<InvoiceModel> result = [];

    for (final invoice in invoices) {
      final items = await db.query(
        DbTables.invoiceItems,
        where: '${InvoiceItemTableColumns.invoiceId} = ?',
        whereArgs: [invoice['id']],
      );

      result.add(
        InvoiceModel.fromMap(
          invoice,
          items.map(InvoiceItemModel.fromMap).toList(),
        ),
      );
    }

    return result;
  }

  Future<void> insertInvoice(InvoiceModel invoice) async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      await txn.insert(
        DbTables.invoices,
        invoice.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final item in invoice.items) {
        await txn.insert(
          DbTables.invoiceItems,
          InvoiceItemModel.fromEntity(item).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> updateInvoice(InvoiceModel invoice) async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      await txn.update(
        DbTables.invoices,
        invoice.toMap(),
        where: '${InvoiceTableColumns.id} = ?',
        whereArgs: [invoice.id],
      );

      await txn.delete(
        DbTables.invoiceItems,
        where: '${InvoiceItemTableColumns.invoiceId} = ?',
        whereArgs: [invoice.id],
      );

      for (final item in invoice.items) {
        await txn.insert(
          DbTables.invoiceItems,
          InvoiceItemModel.fromEntity(item).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> deleteInvoice(String invoiceId) async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      await txn.delete(
        DbTables.invoiceItems,
        where: '${InvoiceItemTableColumns.invoiceId} = ?',
        whereArgs: [invoiceId],
      );

      await txn.delete(
        DbTables.invoices,
        where: '${InvoiceTableColumns.id} = ?',
        whereArgs: [invoiceId],
      );
    });
  }

  Future<List<InvoiceModel>> getInvoicesByCustomerId(String customerId) async {
    final db = await AppDatabase.instance.database;

    final invoiceMaps = await db.query(
      DbTables.invoices,
      where: '${InvoiceTableColumns.customerId} = ?',
      whereArgs: [customerId],
      orderBy: '${InvoiceTableColumns.createdAt} DESC',
    );

    final invoices = <InvoiceModel>[];

    for (final invoiceMap in invoiceMaps) {
      final invoiceId = invoiceMap[InvoiceTableColumns.id] as String;

      final itemMaps = await db.query(
        DbTables.invoiceItems,
        where: '${InvoiceItemTableColumns.invoiceId} = ?',
        whereArgs: [invoiceId],
      );

      final items = itemMaps.map(InvoiceItemModel.fromMap).toList();

      invoices.add(InvoiceModel.fromMap(invoiceMap, items));
    }

    return invoices;
  }
}
