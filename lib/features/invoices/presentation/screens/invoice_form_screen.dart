import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/constants/invoice_status.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';

class InvoiceFormScreen extends StatefulWidget {
  final List<CustomerEntity> customers;
  final List<ProductEntity> products;
  final InvoiceEntity? initialInvoice;

  const InvoiceFormScreen({
    super.key,
    required this.customers,
    required this.products,
    this.initialInvoice,
  });

  bool get isEditMode => initialInvoice != null;

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  CustomerEntity? _selectedCustomer;
  late final List<_InvoiceLineInput> _lines;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialInvoice != null) {
      final invoice = widget.initialInvoice!;
      _selectedCustomer = widget.customers.cast<CustomerEntity?>().firstWhere(
        (c) => c?.id == invoice.customerId,
        orElse: () => null,
      );

      _lines = invoice.items
          .map(
            (item) => _InvoiceLineInput(
              product: widget.products.cast<ProductEntity?>().firstWhere(
                (p) => p?.id == item.productId,
                orElse: () => null,
              ),
              quantity: item.quantity,
            ),
          )
          .toList();

      if (_lines.isEmpty) {
        _lines.add(_InvoiceLineInput());
      }
    } else {
      _lines = [_InvoiceLineInput()];
    }
  }

  double get _total {
    double total = 0;
    for (final line in _lines) {
      if (line.product == null) continue;
      final qty = int.tryParse(line.qtyController.text.trim()) ?? 0;
      total += line.product!.price * qty;
    }
    return total;
  }

  void _addLine() {
    setState(() {
      _lines.add(_InvoiceLineInput());
    });
  }

  void _removeLine(int index) {
    if (_lines.length == 1) return;

    setState(() {
      _lines[index].dispose();
      _lines.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (_selectedCustomer == null) {
      _showError('Please select a customer');
      return;
    }

    final validLines = _lines.where((line) {
      final qty = int.tryParse(line.qtyController.text.trim()) ?? 0;
      return line.product != null && qty > 0;
    }).toList();

    if (validLines.isEmpty) {
      _showError('Add at least one valid invoice item');
      return;
    }

    setState(() => _isSaving = true);

    final invoiceId =
        widget.initialInvoice?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final items = validLines.map((line) {
      final qty = int.parse(line.qtyController.text.trim());
      final product = line.product!;
      final lineTotal = product.price * qty;

      return InvoiceItemEntity(
        id: '${invoiceId}_${product.id}_${qty}_${DateTime.now().microsecondsSinceEpoch}',
        invoiceId: invoiceId,
        productId: product.id,
        productName: product.name,
        unitPrice: product.price,
        quantity: qty,
        lineTotal: lineTotal,
      );
    }).toList();
    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    const paidAmount = 0.0;
    final remainingAmount = totalAmount;
    const status = InvoiceStatus.unpaid;

    final invoice = InvoiceEntity(
      id: invoiceId,
      customerId: _selectedCustomer!.id,
      customerName: _selectedCustomer!.name,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      remainingAmount: remainingAmount,
      status: status,
      createdAt: widget.initialInvoice?.createdAt ?? DateTime.now(),
      items: items,
    );

    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop(invoice);
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
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

    return AppScaffold(
      title: widget.isEditMode ? 'Edit Invoice' : 'Create Invoice',
      useLargeTitle: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<CustomerEntity>(
              value: _selectedCustomer,
              decoration: const InputDecoration(labelText: 'Customer'),
              items: widget.customers
                  .map(
                    (customer) => DropdownMenuItem(
                      value: customer,
                      child: Text(customer.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCustomer = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text('Items', style: textStyles.title3),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addLine,
                  icon: const Icon(CupertinoIcons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(_lines.length, (index) {
              final line = _lines[index];

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
                    children: [
                      DropdownButtonFormField<ProductEntity>(
                        value: line.product,
                        decoration: const InputDecoration(labelText: 'Product'),
                        items: widget.products
                            .map(
                              (product) => DropdownMenuItem(
                                value: product,
                                child: Text(
                                  '${product.name} - \$${product.price.toStringAsFixed(0)}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            line.product = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: line.qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          IconButton(
                            onPressed: () => _removeLine(index),
                            icon: const Icon(CupertinoIcons.trash),
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
                  Text('Invoice Total', style: textStyles.title3),
                  const Spacer(),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: textStyles.amountMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              text: widget.isEditMode ? 'Save Changes' : 'Create Invoice',
              isLoading: _isSaving,
              prefixIcon: Icon(
                widget.isEditMode
                    ? CupertinoIcons.check_mark
                    : CupertinoIcons.add,
              ),
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _InvoiceLineInput {
  ProductEntity? product;
  final TextEditingController qtyController;

  _InvoiceLineInput({this.product, int quantity = 1})
    : qtyController = TextEditingController(text: quantity.toString());

  void dispose() {
    qtyController.dispose();
  }
}
