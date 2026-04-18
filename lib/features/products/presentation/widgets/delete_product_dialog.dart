import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class DeleteProductDialog extends StatelessWidget {
  final String productName;

  const DeleteProductDialog({super.key, required this.productName});

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

    return AlertDialog(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.deleteProductTitle, style: textStyles.title3),
      content: Text(
        l10n.deleteProductMessage(productName),
        style: textStyles.body.copyWith(color: palette.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            l10n.commonDelete,
            style: TextStyle(color: palette.danger),
          ),
        ),
      ],
    );
  }
}
