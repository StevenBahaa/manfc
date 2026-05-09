import '../../data/models/customer_model.dart';

abstract class ICustomerRepository {
  Future<List<CustomerModel>> getAllCustomers();
  Future<CustomerModel?> getCustomerById(String id);
  Future<void> saveCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
}
