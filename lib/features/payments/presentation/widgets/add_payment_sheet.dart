import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../domain/entities/payment_entity.dart';

class AddPaymentSheet extends StatefulWidget {
  final String invoiceId;
  final String customerId;
  final double remainingAmount;

  const AddPaymentSheet({
    super.key,
    required this.invoiceId,
    required this.customerId,
    required this.remainingAmount,
  });

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedMethod = 'cash';
  bool _isSaving = false;
  String? _amountError;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _validateAmount(String value) {
    final amount = double.tryParse(value.trim());

    setState(() {
      if (value.trim().isEmpty) {
        _amountError = null;
        return;
      }

      if (amount == null || amount <= 0) {
        _amountError = 'Enter a valid payment amount';
        return;
      }

      if (amount > widget.remainingAmount) {
        _amountError =
            'Amount cannot exceed \$${widget.remainingAmount.toStringAsFixed(2)}';
        return;
      }

      _amountError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      setState(() {
        _amountError = 'Enter a valid payment amount';
      });
      _showError('Enter a valid payment amount');
      return;
    }

    if (amount > widget.remainingAmount) {
      setState(() {
        _amountError =
            'Amount cannot exceed \$${widget.remainingAmount.toStringAsFixed(2)}';
      });
      _showError('Payment cannot be greater than remaining amount');
      return;
    }

    setState(() {
      _amountError = null;
      _isSaving = true;
    });

    final payment = PaymentEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      invoiceId: widget.invoiceId,
      customerId: widget.customerId,
      amount: amount,
      method: _selectedMethod,
      note: _noteController.text.trim(),
      paymentDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop(payment);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
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

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Add Payment', style: textStyles.title2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Remaining: \$${widget.remainingAmount.toStringAsFixed(2)}',
                style: textStyles.body.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  errorText: _amountError,
                  helperText:
                      'Maximum allowed: \$${widget.remainingAmount.toStringAsFixed(2)}',
                ),
                onChanged: _validateAmount,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(
                    value: 'bank_transfer',
                    child: Text('Bank Transfer'),
                  ),
                  DropdownMenuItem(value: 'card', child: Text('Card')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedMethod = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Optional note',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                text: 'Save Payment',
                isLoading: _isSaving,
                prefixIcon: const Icon(CupertinoIcons.money_dollar_circle),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
