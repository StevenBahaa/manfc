import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

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

    return AlertDialog(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Delete Invoice',
        style: textStyles.title3,
      ),
      content: Text(
        'Are you sure you want to delete invoice #$invoiceId?',
        style: textStyles.body.copyWith(
          color: palette.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Delete',
            style: TextStyle(color: palette.danger),
          ),
        ),
      ],
    );
  }
}