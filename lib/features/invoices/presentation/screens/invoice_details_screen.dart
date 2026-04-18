import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/app/widgets/app_primary_button.dart';
import 'package:manfc/features/payments/domain/utils/invoice_payment_calculator.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../customers/data/datasources/customer_local_datasource.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/data/datasources/product_local_datasource.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../data/datasources/invoice_local_datasource.dart';
import '../../data/models/invoice_item_model.dart';
import '../../data/models/invoice_model.dart';
import '../../domain/entities/invoice_entity.dart';
import 'invoice_form_screen.dart';
import '../../domain/constants/invoice_status.dart';
import '../../../payments/data/datasources/payment_local_data_source.dart';
import '../../../payments/data/models/payment_model.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentation/widgets/add_payment_sheet.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final InvoiceEntity invoice;

  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late InvoiceEntity _invoice;
  List<PaymentModel> _payments = [];

  final PaymentLocalDataSource _paymentLocalDataSource =
      PaymentLocalDataSource.instance;

  final InvoiceLocalDataSource _invoiceLocalDataSource =
      InvoiceLocalDataSource();
  final CustomerLocalDataSource _customerLocalDataSource =
      CustomerLocalDataSource();
  final ProductLocalDataSource _productLocalDataSource =
      ProductLocalDataSource();

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    _payments = await _paymentLocalDataSource.getPaymentsByInvoiceId(
      _invoice.id,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addPayment() async {
    if (_invoice.status == 'paid' ||
        _invoice.status == 'cancelled' ||
        _invoice.status == 'draft') {
      return;
    }

    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final payment = await showModalBottomSheet<PaymentEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddPaymentSheet(
        invoiceId: _invoice.id,
        customerId: _invoice.customerId,
        remainingAmount: _invoice.remainingAmount,
      ),
    );

    if (payment == null) return;

    await _paymentLocalDataSource.insertPayment(
      PaymentModel.fromEntity(payment),
    );

    final totalPaid = await _paymentLocalDataSource.getTotalPaidForInvoice(
      _invoice.id,
    );
    final remainingAmount = InvoicePaymentCalculator.remainingAmount(
      totalAmount: _invoice.totalAmount,
      paidAmount: totalPaid,
    );
    final nextStatus = InvoicePaymentCalculator.status(
      currentStatus: _invoice.status,
      totalAmount: _invoice.totalAmount,
      paidAmount: totalPaid,
    );

    final updatedInvoice = InvoiceModel(
      id: _invoice.id,
      customerId: _invoice.customerId,
      customerName: _invoice.customerName,
      totalAmount: _invoice.totalAmount,
      paidAmount: totalPaid,
      remainingAmount: remainingAmount,
      status: nextStatus,
      createdAt: _invoice.createdAt,
      items: _invoice.items.map(InvoiceItemModel.fromEntity).toList(),
    );

    await _invoiceLocalDataSource.updateInvoice(updatedInvoice);

    setState(() {
      _invoice = updatedInvoice;
    });

    await _loadPayments();
  }

  String _formatAmount(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _editInvoice() async {
    final List<CustomerEntity> customers = await _customerLocalDataSource
        .getAllCustomers();
    final List<ProductEntity> products = await _productLocalDataSource
        .getAllProducts();

    if (!mounted) return;

    final updated = await Navigator.of(context).push<InvoiceEntity>(
      MaterialPageRoute(
        builder: (_) => InvoiceFormScreen(
          customers: customers,
          products: products,
          initialInvoice: _invoice,
        ),
      ),
    );

    if (updated == null) return;

    await _invoiceLocalDataSource.updateInvoice(
      InvoiceModel(
        id: updated.id,
        customerId: updated.customerId,
        customerName: updated.customerName,
        totalAmount: updated.totalAmount,
        paidAmount: updated.paidAmount,
        remainingAmount: updated.remainingAmount,
        status: updated.status,
        createdAt: updated.createdAt,
        items: updated.items.map(InvoiceItemModel.fromEntity).toList(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _invoice = updated;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

    final invoiceRef = _invoice.id.length >= 6
        ? _invoice.id.substring(_invoice.id.length - 6)
        : _invoice.id;

    return AppScaffold(
      title: 'Invoice Details',
      useLargeTitle: false,
      trailing: IconButton(
        onPressed: _editInvoice,
        icon: Icon(CupertinoIcons.pencil, color: palette.iconPrimary),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppSpacing.cardPadding,
          right: AppSpacing.cardPadding,
          top: AppSpacing.lg,
          bottom: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: palette.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Invoice #$invoiceRef',
                          style: textStyles.title2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_invoice.status != 'paid' &&
                      _invoice.status != 'cancelled' &&
                      _invoice.status != 'draft')
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        text: 'Add Payment',
                        prefixIcon: const Icon(
                          CupertinoIcons.money_dollar_circle,
                        ),
                        onPressed: _addPayment,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Customer', value: _invoice.customerName),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Date',
                    value: _formatDate(_invoice.createdAt),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Items Count',
                    value: '${_invoice.items.length}',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Total Amount',
                    value: _formatAmount(_invoice.totalAmount),
                    valueStyle: textStyles.amountMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Status',
                    value: InvoiceStatus.label(_invoice.status),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Paid Amount',
                    value: _formatAmount(_invoice.paidAmount),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: 'Remaining Amount',
                    value: _formatAmount(_invoice.remainingAmount),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Invoice Items', style: textStyles.title3),
            const SizedBox(height: AppSpacing.md),
            ..._invoice.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: palette.border, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName, style: textStyles.title3),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(label: 'Quantity', value: '${item.quantity}'),
                      const SizedBox(height: AppSpacing.xs),
                      _InfoRow(
                        label: 'Unit Price',
                        value: _formatAmount(item.unitPrice),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _InfoRow(
                        label: 'Line Total',
                        value: _formatAmount(item.lineTotal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: palette.border, width: 1),
              ),
              child: Row(
                children: [
                  Text('Grand Total', style: textStyles.title3),
                  const Spacer(),
                  Text(
                    _formatAmount(_invoice.totalAmount),
                    style: textStyles.amountMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Payment History', style: textStyles.title3),
            const SizedBox(height: AppSpacing.md),
            if (_payments.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  'No payments yet',
                  style: textStyles.body.copyWith(color: palette.textSecondary),
                ),
              )
            else
              ..._payments.map(
                (payment) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: palette.border),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isTight = constraints.maxWidth < 360;

                        if (isTight) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: palette.cardBlueSoft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.money_dollar_circle_fill,
                                      color: palette.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      payment.method
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      style: textStyles.bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                payment.note.isEmpty ? 'No note' : payment.note,
                                style: textStyles.caption.copyWith(
                                  color: palette.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '\$${payment.amount.toStringAsFixed(2)}',
                                      style: textStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}',
                                    style: textStyles.caption.copyWith(
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: palette.cardBlueSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CupertinoIcons.money_dollar_circle_fill,
                                color: palette.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    payment.method
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    style: textStyles.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    payment.note.isEmpty
                                        ? 'No note'
                                        : payment.note,
                                    style: textStyles.caption.copyWith(
                                      color: palette.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 84),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${payment.amount.toStringAsFixed(2)}',
                                    style: textStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}',
                                    style: textStyles.caption.copyWith(
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({required this.label, required this.value, this.valueStyle});

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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: textStyles.body.copyWith(color: palette.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: valueStyle ?? textStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}
