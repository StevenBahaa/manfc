import 'package:manfc/l10n/app_localizations.dart';

class CurrencyFormatter {
  static String format(double amount, AppLocalizations l10n) {
    final symbol = l10n.commonCurrency;
    final formattedAmount = amount.toStringAsFixed(2);
    
    // In some locales, the symbol might come after the amount
    if (l10n.localeName == 'ar') {
      return '$formattedAmount $symbol';
    }
    return '$symbol$formattedAmount';
  }

  static String formatCompact(double amount, AppLocalizations l10n) {
    final symbol = l10n.commonCurrency;
    final formattedAmount = amount.toStringAsFixed(0);
    
    if (l10n.localeName == 'ar') {
      return '$formattedAmount $symbol';
    }
    return '$symbol$formattedAmount';
  }
}
