import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../invoices/domain/entities/invoice_entity.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../payments/presentation/providers/payment_providers.dart';

part 'dashboard_providers.g.dart';

class DashboardData {
  final List<CustomerEntity> customers;
  final List<ProductEntity> products;
  final List<InvoiceEntity> invoices;
  final List<PaymentEntity> payments;

  const DashboardData({
    required this.customers,
    required this.products,
    required this.invoices,
    required this.payments,
  });
}

@riverpod
Future<DashboardData> dashboardData(Ref ref) async {
  final customers = await ref.watch(customersProvider.future);
  final products = await ref.watch(productsProvider.future);
  final invoices = await ref.watch(invoicesProvider.future);
  final payments = await ref.watch(paymentsProvider.future);

  return DashboardData(
    customers: customers,
    products: products,
    invoices: invoices,
    payments: payments,
  );
}
