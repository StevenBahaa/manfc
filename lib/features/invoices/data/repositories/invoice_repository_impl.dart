import '../../domain/repositories/i_invoice_repository.dart';
import '../datasources/invoice_local_datasource.dart';
import '../models/invoice_model.dart';

class InvoiceRepositoryImpl implements IInvoiceRepository {
  final InvoiceLocalDataSource _localDataSource;

  InvoiceRepositoryImpl(this._localDataSource);

  @override
  Future<List<InvoiceModel>> getAllInvoices() {
    return _localDataSource.getAllInvoices();
  }

  @override
  Future<InvoiceModel?> getInvoiceById(String id) async {
    final invoices = await _localDataSource.getAllInvoices();
    try {
      return invoices.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveInvoice(InvoiceModel invoice) {
    // This handles both insert and update via conflict algorithm or custom logic
    return _localDataSource.insertInvoice(invoice);
  }

  @override
  Future<void> deleteInvoice(String id) {
    return _localDataSource.deleteInvoice(id);
  }
}
