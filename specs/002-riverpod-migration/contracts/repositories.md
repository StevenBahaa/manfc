# Repository Contracts

## ICustomerRepository
```dart
abstract class ICustomerRepository {
  Future<List<CustomerModel>> getAllCustomers();
  Future<void> saveCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
}
```

## IProductRepository
```dart
abstract class IProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> saveProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
```

## IInvoiceRepository
```dart
abstract class IInvoiceRepository {
  Future<List<InvoiceModel>> getAllInvoices();
  Future<void> saveInvoice(InvoiceModel invoice);
  Future<void> deleteInvoice(String id);
}
```
