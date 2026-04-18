import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return '\$${value.toStringAsFixed(0)}';
    }
    return '\$${value.toStringAsFixed(2)}';
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: palette.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: palette.cardBlueSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      CupertinoIcons.cube_box,
                      color: palette.primary,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    color: palette.surface,
                    surfaceTintColor: Colors.transparent,
                    icon: Icon(
                      CupertinoIcons.ellipsis,
                      color: palette.iconSecondary,
                      size: 18,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(l10n.commonEdit),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.commonDelete),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textStyles.title3,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.productFixedPrice,
                style: textStyles.footnote.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(_formatPrice(product.price), style: textStyles.amountMedium),
            ],
          ),
        ),
      ),
    );
  }
}
