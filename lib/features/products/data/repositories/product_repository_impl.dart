import '../../domain/repositories/i_product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements IProductRepository {
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._localDataSource);

  @override
  Future<List<ProductModel>> getAllProducts() {
    return _localDataSource.getAllProducts();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final products = await _localDataSource.getAllProducts();
    try {
      return products.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProduct(ProductModel product) {
    return _localDataSource.insertProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) {
    return _localDataSource.deleteProduct(id);
  }
}
