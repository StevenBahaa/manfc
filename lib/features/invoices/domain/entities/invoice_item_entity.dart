class InvoiceItemEntity {
  final String id;
  final String invoiceId;
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double lineTotal;

  const InvoiceItemEntity({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });
}
