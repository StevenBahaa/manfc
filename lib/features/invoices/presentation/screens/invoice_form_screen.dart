import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/invoice_entity.dart';
import '../providers/invoice_form_provider.dart';
import 'package:manfc/l10n/app_localizations.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  final List<CustomerEntity> customers;
  final List<ProductEntity> products;
  final InvoiceEntity? initialInvoice;
  final CustomerEntity? customer;

  const InvoiceFormScreen({
    super.key,
    required this.customers,
    required this.products,
    this.initialInvoice,
    this.customer,
  });

  bool get isEditMode => initialInvoice != null;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceFormProvider.notifier).initialize(
            initialInvoice: widget.initialInvoice,
            customer: widget.customer,
          );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickDate(DateTime initialDate) async {
    DateTime? pickedDate;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          final palette = Theme.of(context).brightness == Brightness.dark
              ? AppColors.dark
              : AppColors.light;
          return Container(
            height: 250,
            color: palette.surface,
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                initialDateTime: initialDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  pickedDate = newDate;
                },
              ),
            ),
          );
        },
      );
      if (pickedDate != null) {
        ref.read(invoiceFormProvider.notifier).setDate(pickedDate!);
      }
    } else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        ref.read(invoiceFormProvider.notifier).setDate(pickedDate!);
      }
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final success = await ref.read(invoiceFormProvider.notifier).save();

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      final state = ref.read(invoiceFormProvider);
      final errors = state.validationErrors;
      if (errors.isNotEmpty) {
        _showError(errors.values.first);
      }
    }
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
    final formState = ref.watch(invoiceFormProvider);
    final invoice = formState.invoice;

    if (invoice == null) {
      return const AppScaffold(
        title: '',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AppScaffold(
      title: widget.isEditMode ? l10n.invoiceEditTitle : l10n.invoicesCreateBtn,
      useLargeTitle: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: invoice.customerId.isEmpty ? null : invoice.customerId,
              decoration: InputDecoration(labelText: l10n.invoiceFormCustomer),
              items: widget.customers
                  .map(
                    (customer) => DropdownMenuItem(
                      value: customer.id,
                      child: Text(customer.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final customer =
                      widget.customers.firstWhere((c) => c.id == value);
                  ref.read(invoiceFormProvider.notifier).setCustomer(customer);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: () => _pickDate(invoice.createdAt),
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.invoiceDateLabel,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}',
                      style: textStyles.body,
                    ),
                    Icon(CupertinoIcons.calendar, color: palette.iconSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(l10n.invoiceFormItems, style: textStyles.title3),
                const Spacer(),
                PopupMenuButton<ProductEntity>(
                  onSelected: (product) {
                    ref.read(invoiceFormProvider.notifier).addItem(product);
                  },
                  itemBuilder: (context) => widget.products
                      .map(
                        (p) => PopupMenuItem(
                          value: p,
                          child: Text('${p.name} - \$${p.price.toStringAsFixed(0)}'),
                        ),
                      )
                      .toList(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.add, size: 18),
                        const SizedBox(width: 4),
                        Text(l10n.invoiceFormAddItem),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (invoice.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    l10n.errorAddInvoiceItem,
                    style: textStyles.body.copyWith(color: palette.textSecondary),
                  ),
                ),
              )
            else
              ...invoice.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: palette.border, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: textStyles.body.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '\$${item.unitPrice.toStringAsFixed(2)}',
                              style: textStyles.body,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            IconButton(
                              onPressed: () => ref
                                  .read(invoiceFormProvider.notifier)
                                  .removeItem(item.id),
                              icon: const Icon(CupertinoIcons.trash, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              onPressed: () => ref
                                  .read(invoiceFormProvider.notifier)
                                  .updateItemQuantity(
                                      item.id, item.quantity - 1),
                              icon: const Icon(CupertinoIcons.minus_circle),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: palette.cardBlueSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: textStyles.body.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () => ref
                                  .read(invoiceFormProvider.notifier)
                                  .updateItemQuantity(
                                      item.id, item.quantity + 1),
                              icon: const Icon(CupertinoIcons.plus_circle),
                            ),
                            const Spacer(),
                            Text(
                              '\$${item.lineTotal.toStringAsFixed(2)}',
                              style: textStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: palette.border, width: 1),
              ),
              child: Row(
                children: [
                  Text(l10n.invoiceFormTotal, style: textStyles.title3),
                  const Spacer(),
                  Text(
                    '\$${invoice.totalAmount.toStringAsFixed(2)}',
                    style: textStyles.amountMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              text: widget.isEditMode
                  ? l10n.commonSaveChanges
                  : l10n.invoicesCreateBtn,
              isLoading: formState.isSaving,
              prefixIcon: Icon(
                widget.isEditMode
                    ? CupertinoIcons.check_mark
                    : CupertinoIcons.add,
              ),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
