import 'package:manfc/features/invoices/domain/constants/invoice_status.dart';


class InvoicePaymentCalculator {
  static double remainingAmount({
    required double totalAmount,
    required double paidAmount,
  }) {
    final remaining = totalAmount - paidAmount;
    return remaining < 0 ? 0 : remaining;
  }

  static String status({
    required String currentStatus,
    required double totalAmount,
    required double paidAmount,
  }) {
    return InvoiceStatus.computeFromAmounts(
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      fallbackStatus: currentStatus,
    );
  }
}
