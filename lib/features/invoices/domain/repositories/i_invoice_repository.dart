import '../../data/models/invoice_model.dart';

abstract class IInvoiceRepository {
  Future<List<InvoiceModel>> getAllInvoices();
  Future<InvoiceModel?> getInvoiceById(String id);
  Future<void> saveInvoice(InvoiceModel invoice);
  Future<void> deleteInvoice(String id);
}
