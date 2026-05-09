import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:manfc/l10n/app_localizations.dart';

class DeleteCustomerDialog extends StatelessWidget {
  final String customerName;

  const DeleteCustomerDialog({super.key, required this.customerName});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(AppLocalizations.of(context)!.deleteCustomerTitle, style: textStyles.title3),
      content: Text(
        AppLocalizations.of(context)!.deleteCustomerMessage(customerName),
        style: textStyles.body.copyWith(color: palette.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.commonDelete, style: TextStyle(color: palette.danger)),
        ),
      ],
    );
  }
}
