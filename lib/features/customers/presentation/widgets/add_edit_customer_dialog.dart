import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../domain/entities/customer_entity.dart';

class AddEditCustomerDialog extends StatefulWidget {
  final CustomerEntity? customer;

  const AddEditCustomerDialog({super.key, this.customer});

  bool get isEditMode => customer != null;

  @override
  State<AddEditCustomerDialog> createState() => _AddEditCustomerDialogState();
}

class _AddEditCustomerDialogState extends State<AddEditCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.customer?.name ?? '');

    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Customer name is required';
    if (text.length < 2) return 'Customer name is too short';

    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Phone number is required';
    if (text.length < 6) return 'Enter a valid phone number';

    return null;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    await Future<void>.delayed(const Duration(milliseconds: 200));

    final result = CustomerEntity(
      id:
          widget.customer?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );

    if (!mounted) return;

    setState(() => _isSaving = false);
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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

    return Dialog(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.isEditMode ? 'Edit Customer' : 'Add Customer',
                        style: textStyles.title2,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter the customer details below.',
                  style: textStyles.footnote.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  style: textStyles.body,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    hintText: 'Enter customer name',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: _validatePhone,
                  onFieldSubmitted: (_) => _save(),
                  style: textStyles.body,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppPrimaryButton(
                  text: widget.isEditMode ? 'Save Changes' : 'Create Customer',
                  isLoading: _isSaving,
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
        ),
      ),
    );
  }
}
