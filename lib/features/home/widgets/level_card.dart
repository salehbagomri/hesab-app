import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/models/level.dart';
import '../../../shared/widgets/custom_card.dart';

/// بطاقة عرض المستوى الدراسي
class LevelCard extends StatelessWidget {
  final Level level;
  final VoidCallback onTap;

  const LevelCard({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(level.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),

          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate(level.nameKey),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${level.operationsCount} ${localizations.operationsAvailable}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // السهم
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
