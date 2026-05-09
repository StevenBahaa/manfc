import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../domain/entities/payment_entity.dart';
import 'package:manfc/l10n/app_localizations.dart';

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
  DateTime _selectedDate = DateTime.now();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _validateAmount(String value) {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.tryParse(value.trim());

    setState(() {
      if (value.trim().isEmpty) {
        _amountError = null;
        return;
      }

      if (amount == null || amount <= 0) {
        _amountError = l10n.errorInvalidAmount;
        return;
      }

      if (amount > widget.remainingAmount) {
        _amountError = l10n.errorAmountExceedsRemaining;
        return;
      }

      _amountError = null;
    });
  }

  Future<void> _pickDate() async {
    final initialDate = _selectedDate;
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
        setState(() {
          _selectedDate = pickedDate!;
        });
      }
    } else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate!;
        });
      }
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      setState(() {
        _amountError = l10n.errorInvalidAmount;
      });
      _showError(l10n.errorInvalidAmount);
      return;
    }

    if (amount > widget.remainingAmount) {
      setState(() {
        _amountError = l10n.errorAmountExceedsRemaining;
      });
      _showError(l10n.errorAmountExceedsRemaining);
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
      paymentDate: _selectedDate,
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

    final l10n = AppLocalizations.of(context)!;
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
              Text(AppLocalizations.of(context)!.paymentAddTitle, style: textStyles.title2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${l10n.commonRemaining}: \$${widget.remainingAmount.toStringAsFixed(2)}',
                style: textStyles.body.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.paymentAmountLabel,
                  hintText: l10n.paymentAmountHint,
                  errorText: _amountError,
                  helperText: '${l10n.commonRemaining}: \$${widget.remainingAmount.toStringAsFixed(2)}',
                ),
                onChanged: _validateAmount,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.paymentMethodLabel),
                items: [
                  DropdownMenuItem(value: 'cash', child: Text(AppLocalizations.of(context)!.paymentMethodCash)),
                  DropdownMenuItem(
                    value: 'bank_transfer',
                    child: Text(AppLocalizations.of(context)!.paymentMethodBankTransfer),
                  ),
                  DropdownMenuItem(value: 'card', child: Text(AppLocalizations.of(context)!.paymentMethodCard)),
                  DropdownMenuItem(value: 'other', child: Text(AppLocalizations.of(context)!.paymentMethodOther)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedMethod = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.paymentDateLabel,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: textStyles.body),
                      Icon(CupertinoIcons.calendar, color: palette.iconSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.paymentNoteLabel,
                  hintText: AppLocalizations.of(context)!.paymentNoteHint,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                text: l10n.savePaymentBtn,
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
