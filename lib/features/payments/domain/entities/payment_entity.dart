class PaymentEntity {
  final String id;
  final String invoiceId;
  final String customerId;
  final double amount;
  final String method;
  final String note;
  final DateTime paymentDate;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.invoiceId,
    required this.customerId,
    required this.amount,
    required this.method,
    required this.note,
    required this.paymentDate,
    required this.createdAt,
  });
}
