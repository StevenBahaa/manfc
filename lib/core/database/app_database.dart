import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';
import 'db_tables.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DbConstants.databaseName);

    return openDatabase(
      path,
      version: DbConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createProductsTable(db);
    await _createCustomersTable(db);
    await _createInvoicesTable(db);
    await _createInvoiceItemsTable(db);
    await _createPaymentsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createCustomersTable(db);
    }

    if (oldVersion < 3) {
      await _createInvoicesTable(db);
      await _createInvoiceItemsTable(db);
    }

    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE ${DbTables.invoices} ADD COLUMN ${InvoiceTableColumns.paidAmount} REAL NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE ${DbTables.invoices} ADD COLUMN ${InvoiceTableColumns.remainingAmount} REAL NOT NULL DEFAULT 0',
      );
      await db.execute(
        "ALTER TABLE ${DbTables.invoices} ADD COLUMN ${InvoiceTableColumns.status} TEXT NOT NULL DEFAULT 'unpaid'",
      );
    }

    if (oldVersion < 5) {
      await _createPaymentsTable(db);
    }
  }

  Future<void> _createProductsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTables.products} (
        ${ProductTableColumns.id} TEXT PRIMARY KEY,
        ${ProductTableColumns.name} TEXT NOT NULL,
        ${ProductTableColumns.price} REAL NOT NULL,
        ${ProductTableColumns.createdAt} TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createCustomersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTables.customers} (
        ${CustomerTableColumns.id} TEXT PRIMARY KEY,
        ${CustomerTableColumns.name} TEXT NOT NULL,
        ${CustomerTableColumns.phone} TEXT NOT NULL,
        ${CustomerTableColumns.createdAt} TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createInvoicesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTables.invoices} (
        ${InvoiceTableColumns.id} TEXT PRIMARY KEY,
        ${InvoiceTableColumns.customerId} TEXT NOT NULL,
        ${InvoiceTableColumns.customerName} TEXT NOT NULL,
        ${InvoiceTableColumns.totalAmount} REAL NOT NULL,
        ${InvoiceTableColumns.paidAmount} REAL NOT NULL DEFAULT 0,
        ${InvoiceTableColumns.remainingAmount} REAL NOT NULL DEFAULT 0,
        ${InvoiceTableColumns.status} TEXT NOT NULL DEFAULT 'unpaid',
        ${InvoiceTableColumns.createdAt} TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createInvoiceItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTables.invoiceItems} (
        ${InvoiceItemTableColumns.id} TEXT PRIMARY KEY,
        ${InvoiceItemTableColumns.invoiceId} TEXT NOT NULL,
        ${InvoiceItemTableColumns.productId} TEXT NOT NULL,
        ${InvoiceItemTableColumns.productName} TEXT NOT NULL,
        ${InvoiceItemTableColumns.unitPrice} REAL NOT NULL,
        ${InvoiceItemTableColumns.quantity} INTEGER NOT NULL,
        ${InvoiceItemTableColumns.lineTotal} REAL NOT NULL
      )
    ''');
  }

  Future<void> _createPaymentsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTables.payments} (
        ${PaymentTableColumns.id} TEXT PRIMARY KEY,
        ${PaymentTableColumns.invoiceId} TEXT NOT NULL,
        ${PaymentTableColumns.customerId} TEXT NOT NULL,
        ${PaymentTableColumns.amount} REAL NOT NULL,
        ${PaymentTableColumns.method} TEXT NOT NULL,
        ${PaymentTableColumns.note} TEXT,
        ${PaymentTableColumns.paymentDate} TEXT NOT NULL,
        ${PaymentTableColumns.createdAt} TEXT NOT NULL
      )
    ''');
  }
}
