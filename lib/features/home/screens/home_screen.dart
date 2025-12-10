import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/models/level.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../history/providers/history_provider.dart';
import '../widgets/level_card.dart';

/// الشاشة الرئيسية - عرض المستويات وآخر العمليات
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final recentOperations = ref.watch(historyProvider).take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: localizations.appName),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // عنوان التطبيق والوصف
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.appName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  localizations.appSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // الفاصل
          const Divider(height: 1),

          const SizedBox(height: 16),

          // عنوان اختر المستوى
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              localizations.selectLevel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const SizedBox(height: 16),

          // بطاقات المستويات
          ...Level.all.map((level) {
            return LevelCard(
              level: level,
              onTap: () {
                context.push('/operations/${level.id}');
              },
            );
          }),

          const SizedBox(height: 16),

          // الفاصل
          const Divider(height: 1),

          const SizedBox(height: 16),

          // عنوان آخر العمليات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.recentOperations,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    context.push('/history');
                  },
                  child: Text(localizations.viewAll),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // عرض آخر العمليات أو رسالة فارغة
          if (recentOperations.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.noRecentOperations,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentOperations.map((item) {
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                onTap: () {
                  context.push('/history');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calculate_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.operationType,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.input} = ${item.result}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 16),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: AppColors.background,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_rounded),
            label: localizations.history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: localizations.settings,
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            context.push('/history');
          } else if (index == 2) {
            context.push('/settings');
          }
        },
      ),
    );
  }
}
