import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/math_helper.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../history/providers/history_provider.dart';
import '../models/operation_type.dart';
import '../widgets/explanation_step.dart';

/// شاشة عرض النتيجة مع الشرح التفصيلي
class ResultScreen extends ConsumerWidget {
  final OperationType operationType;
  final List<double> inputs;
  final String level;

  const ResultScreen({
    super.key,
    required this.operationType,
    required this.inputs,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    // حساب النتيجة والحصول على الشرح
    final explanation = MathHelper.calculate(operationType, inputs);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: localizations.result,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/'),
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

          const SizedBox(height: 16),

          // خطوات الشرح
          ...List.generate(
            explanation.steps.length,
            (index) => ExplanationStepWidget(
              step: explanation.steps[index],
              stepNumber: index + 1,
            ),
          ),

          // معلومات إضافية
          if (explanation.additionalInfo != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      explanation.additionalInfo!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: localizations.newOperation,
                  icon: Icons.refresh_rounded,
                  isOutlined: true,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: localizations.saveToHistory,
                  icon: Icons.bookmark_outline_rounded,
                  onPressed: () => _saveToHistory(context, ref),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // زر العودة للرئيسية
          CustomButton(
            text: localizations.home,
            icon: Icons.home_rounded,
            isOutlined: true,
            onPressed: () => context.go('/'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _saveToHistory(BuildContext context, WidgetRef ref) async {
    final explanation = MathHelper.calculate(operationType, inputs);
    final localizations = AppLocalizations.of(context);

    // تحويل الشرح إلى JSON
    final explanationJson = jsonEncode(explanation.toMap());

    // تكوين نص الإدخال
    final inputText = inputs.join(' , ');

    // الحفظ في السجل
    await ref
        .read(historyProvider.notifier)
        .addToHistory(
          level: level,
          operationType: localizations.translate(operationType.translationKey),
          input: inputText,
          result: explanation.result,
          explanation: explanationJson,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.savedToHistory),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
