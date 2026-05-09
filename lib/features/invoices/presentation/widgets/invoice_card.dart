import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/constants/invoice_status.dart';
import '../../domain/entities/invoice_entity.dart';
import 'package:manfc/l10n/app_localizations.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
    this.onDelete,
  });

  Color _statusColor(AppColorPalette palette) {
    switch (invoice.status) {
      case InvoiceStatus.paid:
        return palette.success;
      case InvoiceStatus.partiallyPaid:
        return palette.warning;
      case InvoiceStatus.cancelled:
        return palette.danger;
      case InvoiceStatus.draft:
        return palette.textSecondary;
      case InvoiceStatus.unpaid:
      default:
        return palette.primary;
    }
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

    final invoiceRef = invoice.id.length >= 6
        ? invoice.id.substring(invoice.id.length - 6)
        : invoice.id;

    final statusColor = _statusColor(palette);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: palette.cardBlueSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      CupertinoIcons.doc_text_fill,
                      color: palette.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.invoiceRefTitle(invoiceRef),
                      style: textStyles.title3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    icon: Icon(
                      CupertinoIcons.trash,
                      color: palette.danger,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  invoice.customerName,
                  style: textStyles.body.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      InvoiceStatus.localizedLabel(invoice.status, AppLocalizations.of(context)!),
                      style: textStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  _RightAlignedAmount(
                    label: AppLocalizations.of(context)!.commonTotal,
                    value: CurrencyFormatter.format(invoice.totalAmount, AppLocalizations.of(context)!),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LeftInlineAmount(
                    label: AppLocalizations.of(context)!.commonPaid,
                    value: CurrencyFormatter.format(invoice.paidAmount, AppLocalizations.of(context)!),
                  ),
                  const Spacer(),
                  _RightAlignedAmount(
                    label: AppLocalizations.of(context)!.commonRemaining,
                    value: CurrencyFormatter.format(invoice.remainingAmount, AppLocalizations.of(context)!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RightAlignedAmount extends StatelessWidget {
  final String label;
  final String value;

  const _RightAlignedAmount({required this.label, required this.value});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textAlign: TextAlign.end,
          style: textStyles.caption.copyWith(
            color: palette.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.end,
          style: textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15.5,
          ),
        ),
      ],
    );
  }
}

class _LeftInlineAmount extends StatelessWidget {
  final String label;
  final String value;

  const _LeftInlineAmount({required this.label, required this.value});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.caption.copyWith(
            color: palette.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
