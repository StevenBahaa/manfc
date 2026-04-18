import 'invoice_item_entity.dart';

class InvoiceEntity {
  final String id;
  final String customerId;
  final String customerName;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final DateTime createdAt;
  final List<InvoiceItemEntity> items;

  const InvoiceEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });
}
