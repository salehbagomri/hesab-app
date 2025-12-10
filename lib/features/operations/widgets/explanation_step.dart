import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/explanation.dart';

/// عنصر عرض خطوة من الشرح التفصيلي
class ExplanationStepWidget extends StatelessWidget {
  final ExplanationStep step;
  final int stepNumber;

  const ExplanationStepWidget({
    super.key,
    required this.step,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: step.isHighlighted
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: step.isHighlighted
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.border,
          width: step.isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رقم الخطوة والعنوان
          Row(
            children: [
              if (!step.isHighlighted)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (!step.isHighlighted) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: step.isHighlighted
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // الوصف
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),

          // العرض المرئي (إذا وجد)
          if (step.visual != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                step.visual!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                  height: 1.8,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
