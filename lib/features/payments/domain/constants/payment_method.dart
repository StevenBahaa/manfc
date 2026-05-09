import 'package:manfc/l10n/app_localizations.dart';

abstract final class PaymentMethod {
  static const String cash = 'cash';
  static const String bankTransfer = 'bank_transfer';
  static const String card = 'card';
  static const String other = 'other';

  static String localizedLabel(String method, AppLocalizations l10n) {
    switch (method) {
      case cash:
        return l10n.paymentMethodCash;
      case bankTransfer:
        return l10n.paymentMethodBankTransfer;
      case card:
        return l10n.paymentMethodCard;
      case other:
        return l10n.paymentMethodOther;
      default:
        return method.replaceAll('_', ' ').toUpperCase();
    }
  }
}
