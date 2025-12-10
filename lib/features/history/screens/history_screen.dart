import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../operations/models/explanation.dart';
import '../providers/history_provider.dart';

/// شاشة السجل - عرض العمليات السابقة
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final historyItems = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: localizations.history,
        actions: historyItems.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => _showClearDialog(context, ref),
                  tooltip: localizations.deleteAll,
                ),
              ]
            : null,
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.noRecentOperations,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => _showHistoryDetails(context, item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العملية والنتيجة
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.operationType,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.input} = ${item.result}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.error,
                            ),
                            onPressed: () => _deleteItem(context, ref, item.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // الوقت والمستوى
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(item.timestamp, context),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getLevelName(item.level, context),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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

  void _showHistoryDetails(BuildContext context, dynamic item) {
    final localizations = AppLocalizations.of(context);
    // تحويل JSON إلى Explanation
    Explanation explanation;
    try {
      final explanationMap = jsonDecode(item.explanation);
      explanation = Explanation.fromMap(explanationMap);
    } catch (e) {
      // في حالة الخطأ، نعرض رسالة بسيطة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.errorLoadingDetails)),
      );
      return;
    }

    // الانتقال إلى شاشة التفاصيل
    context.push(
      '/history-detail',
      extra: {'item': item, 'explanation': explanation},
    );
  }

  void _deleteItem(BuildContext context, WidgetRef ref, int id) {
    final localizations = AppLocalizations.of(context);
    ref.read(historyProvider.notifier).deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.deleted),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteHistory),
        content: Text(localizations.confirmDeleteAll),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(context);
            },
            child: Text(
              localizations.deleteAll,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
