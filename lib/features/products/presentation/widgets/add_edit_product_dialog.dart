import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../domain/entities/product_entity.dart';

class AddEditProductDialog extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductDialog({super.key, this.product});

  bool get isEditMode => product != null;

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product?.name ?? '');

    _priceController = TextEditingController(
      text: widget.product != null
          ? _formatInitialPrice(widget.product!.price)
          : '',
    );
  }

  String _formatInitialPrice(double price) {
    if (price == price.roundToDouble()) {
      return price.toStringAsFixed(0);
    }
    return price.toStringAsFixed(2);
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Product name is required';
    if (text.length < 2) return 'Product name is too short';

    return null;
  }

  String? _validatePrice(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Price is required';

    final parsed = double.tryParse(text);
    if (parsed == null) return 'Enter a valid price';
    if (parsed <= 0) return 'Price must be greater than 0';

    return null;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    await Future<void>.delayed(const Duration(milliseconds: 200));

    final result = ProductEntity(
      id:
          widget.product?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );

    if (!mounted) return;

    setState(() => _isSaving = false);
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                        widget.isEditMode
                            ? l10n.productEditTitle
                            : l10n.productAddTitle,
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
                  l10n.productDialogSubtitle,
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
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validatePrice,
                  onFieldSubmitted: (_) => _save(),
                  style: textStyles.body,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter fixed price',
                    prefixText: '\$ ',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppPrimaryButton(
                  text: widget.isEditMode ? 'Save Changes' : 'Create Product',
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
