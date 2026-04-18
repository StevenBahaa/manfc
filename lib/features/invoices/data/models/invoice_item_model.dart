import '../../domain/entities/invoice_item_entity.dart';

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    required super.id,
    required super.invoiceId,
    required super.productId,
    required super.productName,
    required super.unitPrice,
    required super.quantity,
    required super.lineTotal,
  });

  factory InvoiceItemModel.fromEntity(InvoiceItemEntity entity) {
    return InvoiceItemModel(
      id: entity.id,
      invoiceId: entity.invoiceId,
      productId: entity.productId,
      productName: entity.productName,
      unitPrice: entity.unitPrice,
      quantity: entity.quantity,
      lineTotal: entity.lineTotal,
    );
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      id: map['id'] as String,
      invoiceId: map['invoice_id'] as String,
      productId: map['product_id'] as String,
      productName: map['product_name'] as String,
      unitPrice: (map['unit_price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      lineTotal: (map['line_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'product_id': productId,
      'product_name': productName,
      'unit_price': unitPrice,
      'quantity': quantity,
      'line_total': lineTotal,
    };
  }
}
