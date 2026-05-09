import '../../domain/repositories/i_payment_repository.dart';
import '../datasources/payment_local_data_source.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final PaymentLocalDataSource _localDataSource;

  PaymentRepositoryImpl(this._localDataSource);

  @override
  Future<List<PaymentModel>> getAllPayments() {
    return _localDataSource.getAllPayments();
  }

  @override
  Future<List<PaymentModel>> getPaymentsByInvoiceId(String invoiceId) {
    return _localDataSource.getPaymentsByInvoiceId(invoiceId);
  }

  @override
  Future<List<PaymentModel>> getPaymentsByCustomerId(String customerId) {
    return _localDataSource.getPaymentsByCustomerId(customerId);
  }

  @override
  Future<void> savePayment(PaymentModel payment) {
    return _localDataSource.insertPayment(payment);
  }

  @override
  Future<void> deletePayment(String id) {
    // Note: Local datasource missing deletePayment, but we can implement it here or update datasource.
    // For now, mirroring existing capability.
    throw UnimplementedError('Delete payment not implemented in datasource');
  }
}
