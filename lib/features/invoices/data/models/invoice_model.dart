import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import 'invoice_item_model.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    required super.status,
    required super.createdAt,
    required super.items,
  });

  factory InvoiceModel.fromMap(
    Map<String, dynamic> map,
    List<InvoiceItemModel> items,
  ) {
    return InvoiceModel(
      id: map['id'] as String,
      customerId: map['customer_id'] as String,
      customerName: map['customer_name'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      paidAmount: map['paid_amount'] == null
          ? 0
          : (map['paid_amount'] as num).toDouble(),
      remainingAmount: map['remaining_amount'] == null
          ? ((map['total_amount'] as num).toDouble())
          : (map['remaining_amount'] as num).toDouble(),
      status: (map['status'] as String?) ?? 'unpaid',
      createdAt: DateTime.parse(map['created_at'] as String),
      items: items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  InvoiceModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    String? status,
    DateTime? createdAt,
    List<InvoiceItemEntity>? items,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}
