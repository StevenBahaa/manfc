abstract final class DbTables {
  static const String products = 'products';
  static const String customers = 'customers';
  static const String invoices = 'invoices';
  static const String invoiceItems = 'invoice_items';
  static const String payments = 'payments';
}

abstract final class ProductTableColumns {
  static const String id = 'id';
  static const String name = 'name';
  static const String price = 'price';
  static const String createdAt = 'created_at';
}

abstract final class CustomerTableColumns {
  static const String id = 'id';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String createdAt = 'created_at';
}

abstract final class InvoiceTableColumns {
  static const String id = 'id';
  static const String customerId = 'customer_id';
  static const String customerName = 'customer_name';
  static const String totalAmount = 'total_amount';
  static const String paidAmount = 'paid_amount';
  static const String remainingAmount = 'remaining_amount';
  static const String status = 'status';
  static const String createdAt = 'created_at';
}

abstract final class InvoiceItemTableColumns {
  static const String id = 'id';
  static const String invoiceId = 'invoice_id';
  static const String productId = 'product_id';
  static const String productName = 'product_name';
  static const String unitPrice = 'unit_price';
  static const String quantity = 'quantity';
  static const String lineTotal = 'line_total';
}

abstract final class PaymentTableColumns {
  static const String id = 'id';
  static const String invoiceId = 'invoice_id';
  static const String customerId = 'customer_id';
  static const String amount = 'amount';
  static const String method = 'method';
  static const String note = 'note';
  static const String paymentDate = 'payment_date';
  static const String createdAt = 'created_at';
}
