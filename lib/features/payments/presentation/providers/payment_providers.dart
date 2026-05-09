import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/payment_local_data_source.dart';
import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/i_payment_repository.dart';

part 'payment_providers.g.dart';

@riverpod
PaymentLocalDataSource paymentLocalDataSource(Ref ref) {
  return PaymentLocalDataSource.instance;
}

@riverpod
IPaymentRepository paymentRepository(Ref ref) {
  final dataSource = ref.watch(paymentLocalDataSourceProvider);
  return PaymentRepositoryImpl(dataSource);
}

@riverpod
Future<List<PaymentModel>> payments(Ref ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getAllPayments();
}
