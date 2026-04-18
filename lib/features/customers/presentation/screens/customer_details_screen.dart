import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/features/invoices/data/datasources/invoice_local_datasource.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../invoices/data/models/invoice_model.dart';
import '../../../payments/data/datasources/payment_local_data_source.dart';
import '../../../payments/data/models/payment_model.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerEntity customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final InvoiceLocalDataSource _invoiceLocalDataSource =
      InvoiceLocalDataSource();
  final PaymentLocalDataSource _paymentLocalDataSource =
      PaymentLocalDataSource.instance;

  bool _isLoading = true;
  List<InvoiceModel> _invoices = [];
  List<PaymentModel> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final invoices = await _invoiceLocalDataSource.getInvoicesByCustomerId(
      widget.customer.id,
    );
    final payments = await _paymentLocalDataSource.getPaymentsByCustomerId(
      widget.customer.id,
    );

    if (!mounted) return;

    setState(() {
      _invoices = invoices;
      _payments = payments;
      _isLoading = false;
    });
  }

  double get _totalInvoiced {
    return _invoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.totalAmount,
    );
  }

  double get _totalPaid {
    return _payments.fold<double>(0, (sum, payment) => sum + payment.amount);
  }

  double get _outstanding {
    final value = _totalInvoiced - _totalPaid;
    return value < 0 ? 0 : value;
  }

  List<_LedgerEntry> get _ledgerEntries {
    final entries = <_LedgerEntry>[
      ..._invoices.map((invoice) => _LedgerEntry.invoice(invoice)),
      ..._payments.map((payment) => _LedgerEntry.payment(payment)),
    ];

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
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

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(title: const Text('Customer Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _CustomerHeaderCard(
                    customerName: widget.customer.name,
                    phone: widget.customer.phone,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Overview', style: textStyles.title3),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Invoiced',
                          value: '\$${_totalInvoiced.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Paid',
                          value: '\$${_totalPaid.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SummaryCard(
                    title: 'Outstanding',
                    value: '\$${_outstanding.toStringAsFixed(2)}',
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Ledger', style: textStyles.title3),
                  const SizedBox(height: AppSpacing.md),
                  if (_ledgerEntries.isEmpty)
                    const _EmptyCard(
                      message: 'No activity for this customer yet',
                    )
                  else
                    ...List.generate(
                      _ledgerEntries.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _ledgerEntries.length - 1
                              ? 0
                              : AppSpacing.md,
                        ),
                        child: _LedgerTimelineTile(
                          entry: _ledgerEntries[index],
                          isLast: index == _ledgerEntries.length - 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
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

  factory _LedgerEntry.invoice(InvoiceModel invoice) {
    final ref = invoice.id.length >= 6
        ? invoice.id.substring(invoice.id.length - 6)
        : invoice.id;

    return _LedgerEntry(
      type: 'invoice',
      date: invoice.createdAt,
      title: 'Invoice #$ref created',
      subtitle: 'Added to customer balance',
      amount: invoice.totalAmount,
      isPositive: true,
    );
  }

  factory _LedgerEntry.payment(PaymentModel payment) {
    return _LedgerEntry(
      type: 'payment',
      date: payment.paymentDate,
      title: 'Payment received',
      subtitle: payment.note.isEmpty
          ? _formatMethod(payment.method)
          : '${_formatMethod(payment.method)} • ${payment.note}',
      amount: payment.amount,
      isPositive: false,
    );
  }

  static String _formatMethod(String method) {
    switch (method) {
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'card':
        return 'Card';
      case 'cash':
        return 'Cash';
      case 'other':
      default:
        return 'Other';
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
