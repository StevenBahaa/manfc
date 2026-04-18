import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../domain/entities/product_entity.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductScreen({super.key, this.product});

  bool get isEditMode => product != null;

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
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
    final l10n = AppLocalizations.of(context)!;
    final text = value?.trim() ?? '';

    if (text.isEmpty) return l10n.productNameRequired;
    if (text.length < 2) return l10n.productNameTooShort;

    return null;
  }

  String? _validatePrice(String? value) {
    final l10n = AppLocalizations.of(context)!;

    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Price is required';
    }

    final parsed = double.tryParse(text);

    if (text.isEmpty) return l10n.productPriceRequired;
    if (parsed == null) return l10n.productPriceInvalid;
    if (parsed <= 0) return l10n.productPricePositive;

    return null;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    await Future<void>.delayed(const Duration(milliseconds: 250));

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

    return AppScaffold(
      title: widget.isEditMode ? l10n.productEditTitle : l10n.productAddTitle,
      useLargeTitle: false,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.productDetailsTitle, style: textStyles.title3),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.productDetailsSubtitle,
              style: textStyles.footnote.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              validator: _validateName,
              style: textStyles.body,
              decoration: InputDecoration(
                labelText: l10n.productNameLabel,
                hintText: l10n.productNameHint,
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
              decoration: InputDecoration(
                labelText: l10n.productPriceLabel,
                hintText: l10n.productPriceHint,
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: palette.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.info_circle,
                    color: palette.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.productUsageInfo,
                      style: textStyles.footnote.copyWith(
                        color: palette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppPrimaryButton(
              text: widget.isEditMode ? l10n.productSaveChanges : l10n.productCreateButton,
              isLoading: _isSaving,
              prefixIcon: Icon(
                widget.isEditMode
                    ? CupertinoIcons.check_mark
                    : CupertinoIcons.add,
              ),
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
