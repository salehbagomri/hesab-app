import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/operation_type.dart';

/// بطاقة عرض العملية الحسابية
class OperationCard extends StatelessWidget {
  final OperationType operationType;
  final VoidCallback onTap;

  const OperationCard({
    super.key,
    required this.operationType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(operationType.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),

          // النص
          Expanded(
            child: Text(
              localizations.translate(operationType.translationKey),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          // السهم
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
