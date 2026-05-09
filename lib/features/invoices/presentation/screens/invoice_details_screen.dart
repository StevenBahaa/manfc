import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manfc/app/widgets/app_primary_button.dart';
import 'package:manfc/features/payments/domain/utils/invoice_payment_calculator.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../data/models/invoice_item_model.dart';
import '../../data/models/invoice_model.dart';
import '../../domain/entities/invoice_entity.dart';
import 'invoice_form_screen.dart';
import '../../domain/constants/invoice_status.dart';
import '../../../payments/data/models/payment_model.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentation/widgets/add_payment_sheet.dart';
import '../../../payments/domain/constants/payment_method.dart';
import '../providers/invoice_providers.dart';
import '../../../payments/presentation/providers/payment_providers.dart';
import 'package:manfc/l10n/app_localizations.dart';

class InvoiceDetailsScreen extends ConsumerStatefulWidget {
  final InvoiceEntity invoice;

  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  ConsumerState<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends ConsumerState<InvoiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _addPayment(InvoiceEntity invoice) async {
    if (invoice.status == 'paid' ||
        invoice.status == 'cancelled' ||
        invoice.status == 'draft') {
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
        invoiceId: invoice.id,
        customerId: invoice.customerId,
        remainingAmount: invoice.remainingAmount,
      ),
    );

    if (payment == null) return;

    final paymentRepository = ref.read(paymentRepositoryProvider);
    await paymentRepository.savePayment(
      PaymentModel.fromEntity(payment),
    );

    final allPayments = await paymentRepository.getAllPayments();
    final invoicePayments = allPayments.where((p) => p.invoiceId == invoice.id);
    final totalPaid = invoicePayments.fold<double>(0, (sum, p) => sum + p.amount);

    final remainingAmount = InvoicePaymentCalculator.remainingAmount(
      totalAmount: invoice.totalAmount,
      paidAmount: totalPaid,
    );
    final nextStatus = InvoicePaymentCalculator.status(
      currentStatus: invoice.status,
      totalAmount: invoice.totalAmount,
      paidAmount: totalPaid,
    );

    final updatedInvoice = InvoiceModel(
      id: invoice.id,
      customerId: invoice.customerId,
      customerName: invoice.customerName,
      totalAmount: invoice.totalAmount,
      paidAmount: totalPaid,
      remainingAmount: remainingAmount,
      status: nextStatus,
      createdAt: invoice.createdAt,
      items: invoice.items.map(InvoiceItemModel.fromEntity).toList(),
    );

    await ref.read(invoiceRepositoryProvider).saveInvoice(updatedInvoice);

    ref.invalidate(invoicesProvider);
    ref.invalidate(paymentsProvider);
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

  Future<void> _editInvoice(InvoiceEntity invoice) async {
    final customers = await ref.read(customersProvider.future);
    final products = await ref.read(productsProvider.future);

    if (!mounted) return;

    final updated = await Navigator.of(context).push<InvoiceEntity>(
      MaterialPageRoute(
        builder: (_) => InvoiceFormScreen(
          customers: customers,
          products: products,
          initialInvoice: invoice,
        ),
      ),
    );

    if (updated == null) return;

    final repository = ref.read(invoiceRepositoryProvider);
    await repository.saveInvoice(
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

    ref.invalidate(invoicesProvider);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.invoiceUpdatedMessage),
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

    final l10n = AppLocalizations.of(context)!;
    
    final invoicesAsync = ref.watch(invoicesProvider);
    final paymentsAsync = ref.watch(paymentsProvider);

    return invoicesAsync.when(
      loading: () => const AppScaffold(title: '', child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => AppScaffold(title: 'Error', child: Center(child: Text('Error: $err'))),
      data: (allInvoices) {
        final currentInvoice = allInvoices.firstWhere(
          (i) => i.id == widget.invoice.id,
          orElse: () => widget.invoice as InvoiceModel,
        );

        final invoiceRef = currentInvoice.id.length >= 6
            ? currentInvoice.id.substring(currentInvoice.id.length - 6)
            : currentInvoice.id;

        return AppScaffold(
          title: l10n.invoiceDetailsTitle,
          useLargeTitle: false,
          trailing: IconButton(
            onPressed: () => _editInvoice(currentInvoice),
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
                              l10n.invoiceRefTitle(invoiceRef),
                              style: textStyles.title2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (currentInvoice.status != 'paid' &&
                          currentInvoice.status != 'cancelled' &&
                          currentInvoice.status != 'draft')
                        SizedBox(
                          width: double.infinity,
                          child: AppPrimaryButton(
                            text: l10n.invoiceAddPaymentBtn,
                            prefixIcon: const Icon(
                              CupertinoIcons.money_dollar_circle,
                            ),
                            onPressed: () => _addPayment(currentInvoice),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(label: l10n.commonCustomer, value: currentInvoice.customerName),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.commonDate,
                        value: _formatDate(currentInvoice.createdAt),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.invoiceItemsCount,
                        value: '${currentInvoice.items.length}',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.commonTotal,
                        value: _formatAmount(currentInvoice.totalAmount),
                        valueStyle: textStyles.amountMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.commonStatus,
                        value: InvoiceStatus.localizedLabel(currentInvoice.status, l10n),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.commonPaid,
                        value: _formatAmount(currentInvoice.paidAmount),
                        valueStyle: textStyles.amountSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: l10n.commonRemaining,
                        value: _formatAmount(currentInvoice.remainingAmount),
                        valueStyle: textStyles.amountMedium.copyWith(
                        color: currentInvoice.remainingAmount > 0
                              ? palette.success
                              : palette.danger,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.invoiceItemsTitle, style: textStyles.title3),
                const SizedBox(height: AppSpacing.md),
                ...currentInvoice.items.map(
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
                          _InfoRow(label: l10n.commonQuantity, value: '${item.quantity}'),
                          const SizedBox(height: AppSpacing.sm),
                          _InfoRow(
                            label: l10n.commonUnitPrice,
                            value: _formatAmount(item.unitPrice),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _InfoRow(
                            label: l10n.invoiceLineTotal,
                            value: _formatAmount(item.lineTotal),
                            valueStyle: textStyles.amountSmall,
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
                      Text(l10n.invoiceGrandTotal, style: textStyles.title3),
                      const Spacer(),
                      Text(
                        _formatAmount(currentInvoice.totalAmount),
                        style: textStyles.amountMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.invoicePaymentHistory, style: textStyles.title3),
                const SizedBox(height: AppSpacing.md),
                paymentsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading payments: $err'),
                  data: (allPayments) {
                    final payments = allPayments.where((p) => p.invoiceId == currentInvoice.id).toList();
                    if (payments.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.cardPadding),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: palette.border),
                        ),
                        child: Text(
                          l10n.invoiceNoPaymentsYet,
                          style: textStyles.body.copyWith(color: palette.textSecondary),
                        ),
                      );
                    }
                    return Column(
                      children: payments.map(
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
                                              PaymentMethod.localizedLabel(
                                                payment.method,
                                                l10n,
                                              ),
                                              style: textStyles.bodyMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      _InfoRow(
                                        label: l10n.paymentNoteLabel,
                                        value: payment.note.isEmpty ? l10n.commonNoNote : payment.note,
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
                                            PaymentMethod.localizedLabel(
                                              payment.method,
                                              l10n,
                                            ),
                                            style: textStyles.bodyMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            payment.note.isEmpty
                                                ? l10n.commonNoNote
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
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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
