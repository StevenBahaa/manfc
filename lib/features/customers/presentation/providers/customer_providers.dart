import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/customer_local_datasource.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/i_customer_repository.dart';

part 'customer_providers.g.dart';

@riverpod
CustomerLocalDataSource customerLocalDataSource(Ref ref) {
  return CustomerLocalDataSource();
}

@riverpod
ICustomerRepository customerRepository(Ref ref) {
  final dataSource = ref.watch(customerLocalDataSourceProvider);
  return CustomerRepositoryImpl(dataSource);
}

@riverpod
Future<List<CustomerModel>> customers(Ref ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getAllCustomers();
}
