import '../../domain/repositories/i_customer_repository.dart';
import '../datasources/customer_local_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements ICustomerRepository {
  final CustomerLocalDataSource _localDataSource;

  CustomerRepositoryImpl(this._localDataSource);

  @override
  Future<List<CustomerModel>> getAllCustomers() {
    return _localDataSource.getAllCustomers();
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    final customers = await _localDataSource.getAllCustomers();
    try {
      return customers.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCustomer(CustomerModel customer) {
    return _localDataSource.insertCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(String id) {
    return _localDataSource.deleteCustomer(id);
  }
}
