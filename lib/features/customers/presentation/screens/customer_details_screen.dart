import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../payments/presentation/providers/payment_providers.dart';
import '../../../invoices/domain/entities/invoice_entity.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../domain/entities/customer_entity.dart';
import 'package:manfc/l10n/app_localizations.dart';

class CustomerDetailsScreen extends ConsumerWidget {
  final CustomerEntity customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final invoicesAsync = ref.watch(invoicesProvider);
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customerDetailsTitle),
      ),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (allInvoices) {
          final customerInvoices = allInvoices.where((i) => i.customerId == customer.id).toList();
          
          return paymentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (allPayments) {
              final customerPayments = allPayments.where((p) => p.customerId == customer.id).toList();

              final totalInvoiced = customerInvoices.fold<double>(0, (sum, i) => sum + i.totalAmount);
              final totalPaid = customerPayments.fold<double>(0, (sum, p) => sum + p.amount);
              final outstanding = totalInvoiced - totalPaid;
              
              final ledgerEntries = _getLedgerEntries(customerInvoices, customerPayments, AppLocalizations.of(context)!);

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _CustomerHeaderCard(
                    customerName: customer.name,
                    phone: customer.phone,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppLocalizations.of(context)!.customerOverview,
                    style: textStyles.title3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: AppLocalizations.of(context)!.customerStatsInvoiced,
                          value: '\$${totalInvoiced.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _SummaryCard(
                          title: AppLocalizations.of(context)!.customerStatsPaid,
                          value: '\$${totalPaid.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SummaryCard(
                    title: AppLocalizations.of(context)!.customerStatsOutstanding,
                    value: '\$${(outstanding < 0 ? 0 : outstanding).toStringAsFixed(2)}',
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppLocalizations.of(context)!.customerLedger,
                    style: textStyles.title3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (ledgerEntries.isEmpty)
                    _EmptyCard(
                      message: AppLocalizations.of(context)!.customerNoActivity,
                    )
                  else
                    ...List.generate(
                      ledgerEntries.length,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == ledgerEntries.length - 1
                                ? 0
                                : AppSpacing.md,
                          ),
                          child: _LedgerTimelineTile(
                            entry: ledgerEntries[index],
                            isLast: index == ledgerEntries.length - 1,
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<_LedgerEntry> _getLedgerEntries(
    List<InvoiceEntity> invoices,
    List<PaymentEntity> payments,
    AppLocalizations l10n,
  ) {
    final entries = <_LedgerEntry>[
      ...invoices.map((invoice) => _LedgerEntry.invoice(invoice, l10n)),
      ...payments.map((payment) => _LedgerEntry.payment(payment, l10n)),
    ];

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }
}

class _LedgerEntry {
  final String type;
  final DateTime date;
  final String title;
  final String subtitle;
  final double amount;
  final bool isPositive;

  const _LedgerEntry({
    required this.type,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  factory _LedgerEntry.invoice(InvoiceEntity invoice, AppLocalizations l10n) {
    final ref = invoice.id.length >= 6
        ? invoice.id.substring(invoice.id.length - 6)
        : invoice.id;

    return _LedgerEntry(
      type: 'invoice',
      date: invoice.createdAt,
      title: l10n.customerLedgerInvoiceCreated(ref),
      subtitle: l10n.customerLedgerInvoiceDesc,
      amount: invoice.totalAmount,
      isPositive: true,
    );
  }

  factory _LedgerEntry.payment(PaymentEntity payment, AppLocalizations l10n) {
    return _LedgerEntry(
      type: 'payment',
      date: payment.paymentDate,
      title: l10n.customerLedgerPaymentReceived,
      subtitle: payment.note.isEmpty
          ? _formatMethod(payment.method, l10n)
          : '${_formatMethod(payment.method, l10n)} • ${payment.note}',
      amount: payment.amount,
      isPositive: false,
    );
  }

  static String _formatMethod(String method, AppLocalizations l10n) {
    switch (method) {
      case 'bank_transfer':
        return l10n.paymentMethodBankTransfer;
      case 'card':
        return l10n.paymentMethodCard;
      case 'cash':
        return l10n.paymentMethodCash;
      case 'other':
      default:
        return l10n.paymentMethodOther;
    }
  }
}

class _CustomerHeaderCard extends StatelessWidget {
  final String customerName;
  final String phone;

  const _CustomerHeaderCard({required this.customerName, required this.phone});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: palette.cardBlueSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              color: palette.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: textStyles.title3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: textStyles.body.copyWith(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final bool fullWidth;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyles.caption.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textStyles.title3.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LedgerTimelineTile extends StatelessWidget {
  final _LedgerEntry entry;
  final bool isLast;

  const _LedgerTimelineTile({required this.entry, required this.isLast});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final amountColor = entry.isPositive ? palette.primary : palette.success;
    final amountPrefix = entry.isPositive ? '+' : '-';
    final icon = entry.type == 'invoice'
        ? CupertinoIcons.doc_text_fill
        : CupertinoIcons.money_dollar_circle_fill;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.cardBlueSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: palette.primary, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 34,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: textStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.subtitle,
                    style: textStyles.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(entry.date),
                    style: textStyles.caption.copyWith(
                      color: palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '$amountPrefix\$${entry.amount.toStringAsFixed(2)}',
              style: textStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        message,
        style: textStyles.body.copyWith(color: palette.textSecondary),
      ),
    );
  }
}
