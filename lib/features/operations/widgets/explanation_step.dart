import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../models/explanation.dart';

/// عنصر عرض خطوة من الشرح التفصيلي - تصميم احترافي محسّن
class ExplanationStepWidget extends StatelessWidget {
  final ExplanationStep step;
  final int stepNumber;

  const ExplanationStepWidget({
    super.key,
    required this.step,
    required this.stepNumber,
  });

  /// ترجمة النص إذا كان مفتاح ترجمة، وإلا عرضه كما هو
  String _translateOrKeep(BuildContext context, String text) {
    final localizations = AppLocalizations.of(context);
    // محاولة ترجمة النص، إذا لم يكن مفتاح صالح سيعيد النص الأصلي
    return localizations.translate(text);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: step.isHighlighted
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.withOpacity(0.15),
          width: step.isHighlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: step.isHighlighted
                ? AppColors.primary.withOpacity(0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: step.isHighlighted ? 16 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس الخطوة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: step.isHighlighted
                    ? [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ]
                    : [
                        Colors.grey.withOpacity(0.05),
                        Colors.grey.withOpacity(0.02),
                      ],
                begin: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                end: isRTL ? Alignment.centerLeft : Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                // رقم الخطوة
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: step.isHighlighted
                          ? [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ]
                          : [Colors.grey.shade400, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (step.isHighlighted
                                    ? AppColors.primary
                                    : Colors.grey)
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // عنوان الخطوة
                Expanded(
                  child: Text(
                    _translateOrKeep(context, step.title),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: step.isHighlighted
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),

                // أيقونة الحالة
                if (step.isHighlighted)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          // محتوى الخطوة
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الوصف
                Text(
                  _translateOrKeep(context, step.description),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.7,
                    fontSize: 15,
                  ),
                ),

                // العرض المرئي (إذا وجد)
                if (step.visual != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surface,
                          AppColors.surface.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.functions_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            step.visual!,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  color: AppColors.textPrimary,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
