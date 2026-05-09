import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:manfc/l10n/app_localizations.dart';

class DeleteInvoiceDialog extends StatelessWidget {
  final String invoiceId;

  const DeleteInvoiceDialog({
    super.key,
    required this.invoiceId,
  });

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

    return AlertDialog(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        l10n.deleteInvoiceTitle,
        style: textStyles.title3,
      ),
      content: Text(
        l10n.deleteInvoiceMessage(invoiceId),
        style: textStyles.body.copyWith(
          color: palette.textSecondary,
        ),
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