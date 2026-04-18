import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/db_tables.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  ProductLocalDataSource();

  Future<List<ProductModel>> getAllProducts() async {
    final Database db = await AppDatabase.instance.database;

    final result = await db.query(
      DbTables.products,
      orderBy: '${ProductTableColumns.createdAt} DESC',
    );

    return result.map(ProductModel.fromMap).toList();
  }

  Future<void> insertProduct(ProductModel product) async {
    final Database db = await AppDatabase.instance.database;

    await db.insert(
      DbTables.products,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    final Database db = await AppDatabase.instance.database;

    await db.update(
      DbTables.products,
      product.toMap(),
      where: '${ProductTableColumns.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String productId) async {
    final Database db = await AppDatabase.instance.database;

    await db.delete(
      DbTables.products,
      where: '${ProductTableColumns.id} = ?',
      whereArgs: [productId],
    );
  }
}
