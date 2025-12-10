import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/models/level.dart';
import '../models/operation_type.dart';
import '../widgets/operation_card.dart';

/// شاشة قائمة العمليات المتاحة للمستوى المختار
class OperationsListScreen extends StatelessWidget {
  final String levelId;

  const OperationsListScreen({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final level = Level.getById(levelId);

    if (level == null) {
      return Scaffold(body: Center(child: Text(localizations.levelNotFound)));
    }

    // الحصول على العمليات المتاحة للمستوى
    final operations = _getOperationsForLevel(levelId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: localizations.translate(level.nameKey),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // معلومات المستوى
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(level.icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.translate(level.nameKey),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${operations.length} ${localizations.operationsAvailable}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // قائمة العمليات
          ...operations.map((operationType) {
            return OperationCard(
              operationType: operationType,
              onTap: () {
                context.push(
                  '/operation-input',
                  extra: {'operationType': operationType, 'level': levelId},
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// الحصول على العمليات المتاحة حسب المستوى
  List<OperationType> _getOperationsForLevel(String levelId) {
    return OperationType.values.where((op) => op.level == levelId).toList();
  }
}
