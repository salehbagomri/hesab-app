import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../operations/models/explanation.dart';
import '../../operations/widgets/explanation_step.dart';
import '../models/history_item.dart';

/// شاشة تفاصيل عملية من السجل
class HistoryDetailScreen extends StatelessWidget {
  final HistoryItem item;
  final Explanation explanation;

  const HistoryDetailScreen({
    super.key,
    required this.item,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: item.operationType,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة النتيجة
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  localizations.result,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation.result,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // معلومات العملية
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  context,
                  Icons.calculate_rounded,
                  localizations.inputs,
                  item.input,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  localizations.time,
                  _formatTimestamp(item.timestamp, context),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  Icons.school_rounded,
                  localizations.level,
                  _getLevelName(item.level, context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // عنوان الشرح
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.explanation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // خطوات الشرح
          ...explanation.steps.asMap().entries.map((entry) {
            return ExplanationStepWidget(
              stepNumber: entry.key + 1,
              step: entry.value,
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${localizations.ago} ${difference.inDays} ${localizations.daysAgo}';
    } else if (difference.inHours > 0) {
      return '${localizations.ago} ${difference.inHours} ${localizations.hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${localizations.ago} ${difference.inMinutes} ${localizations.minutesAgo}';
    } else {
      return localizations.justNow;
    }
  }

  String _getLevelName(String level, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    switch (level) {
      case 'elementary':
        return localizations.elementary;
      case 'middle':
        return localizations.middle;
      case 'high':
        return localizations.high;
      default:
        return level;
    }
  }
}
