import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/i_product_repository.dart';

part 'product_providers.g.dart';

@riverpod
ProductLocalDataSource productLocalDataSource(Ref ref) {
  return ProductLocalDataSource();
}

@riverpod
IProductRepository productRepository(Ref ref) {
  final dataSource = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
}

@riverpod
Future<List<ProductModel>> products(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllProducts();
}
