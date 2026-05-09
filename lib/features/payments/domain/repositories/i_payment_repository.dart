import '../../data/models/payment_model.dart';

abstract class IPaymentRepository {
  Future<List<PaymentModel>> getAllPayments();
  Future<List<PaymentModel>> getPaymentsByInvoiceId(String invoiceId);
  Future<List<PaymentModel>> getPaymentsByCustomerId(String customerId);
  Future<void> savePayment(PaymentModel payment);
  Future<void> deletePayment(String id);
}
