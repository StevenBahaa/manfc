import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.invoiceId,
    required super.customerId,
    required super.amount,
    required super.method,
    required super.note,
    required super.paymentDate,
    required super.createdAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as String,
      invoiceId: map['invoice_id'] as String,
      customerId: map['customer_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      method: map['method'] as String,
      note: (map['note'] as String?) ?? '',
      paymentDate: DateTime.parse(map['payment_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'customer_id': customerId,
      'amount': amount,
      'method': method,
      'note': note,
      'payment_date': paymentDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      invoiceId: entity.invoiceId,
      customerId: entity.customerId,
      amount: entity.amount,
      method: entity.method,
      note: entity.note,
      paymentDate: entity.paymentDate,
      createdAt: entity.createdAt,
    );
  }
}
