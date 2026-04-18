import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerCard extends StatelessWidget {
  final CustomerEntity customer;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onEdit,
    this.onDelete,
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
                      CupertinoIcons.person_fill,
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
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                customer.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textStyles.title3,
              ),
              const SizedBox(height: 8),
              Text(
                'Phone Number',
                style: textStyles.footnote.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(customer.phone, style: textStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
