import 'package:manfc/l10n/app_localizations.dart';

abstract final class InvoiceStatus {
  static const String draft = 'draft';
  static const String unpaid = 'unpaid';
  static const String partiallyPaid = 'partially_paid';
  static const String paid = 'paid';
  static const String cancelled = 'cancelled';

  static const List<String> editableStatuses = [draft, unpaid, cancelled];

  static String computeFromAmounts({
    required double totalAmount,
    required double paidAmount,
    required String fallbackStatus,
  }) {
    if (fallbackStatus == cancelled) return cancelled;
    if (fallbackStatus == draft) return draft;

    if (paidAmount <= 0) return unpaid;
    if (paidAmount >= totalAmount) return paid;
    return partiallyPaid;
  }

  /// Returns the localized label for a given invoice status.
  static String localizedLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case draft:
        return l10n.statusDraft;
      case unpaid:
        return l10n.statusUnpaid;
      case partiallyPaid:
        return l10n.statusPartiallyPaid;
      case paid:
        return l10n.statusPaid;
      case cancelled:
        return l10n.statusCancelled;
      default:
        return l10n.statusUnknown;
    }
  }

  /// Non-localized fallback label (for data/logging).
  static String label(String status) {
    switch (status) {
      case draft:
        return 'Draft';
      case unpaid:
        return 'Unpaid';
      case partiallyPaid:
        return 'Partially Paid';
      case paid:
        return 'Paid';
      case cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
