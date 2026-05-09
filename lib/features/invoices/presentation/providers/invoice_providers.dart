import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/invoice_local_datasource.dart';
import '../../data/models/invoice_model.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/i_invoice_repository.dart';

part 'invoice_providers.g.dart';

@riverpod
InvoiceLocalDataSource invoiceLocalDataSource(Ref ref) {
  return InvoiceLocalDataSource();
}

@riverpod
IInvoiceRepository invoiceRepository(Ref ref) {
  final dataSource = ref.watch(invoiceLocalDataSourceProvider);
  return InvoiceRepositoryImpl(dataSource);
}

@riverpod
Future<List<InvoiceModel>> invoices(Ref ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getAllInvoices();
}
