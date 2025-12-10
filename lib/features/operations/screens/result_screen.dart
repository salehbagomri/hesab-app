import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// شاشة عرض النتيجة مع الشرح التفصيلي - تصميم احترافي متقدم
class ResultScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final explanation = MathHelper.calculate(
      widget.operationType,
      widget.inputs,
    );
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: localizations.result,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
            onPressed: () => _shareResult(context, explanation, localizations),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy',
            onPressed: () => _copyResult(context, explanation, localizations),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildResultCard(context, explanation, localizations),
              const SizedBox(height: 32),
              _buildInputsCard(context, localizations, isRTL),
              const SizedBox(height: 32),
              _buildExplanationSection(context, explanation, localizations),
              if (explanation.additionalInfo != null) ...[
                const SizedBox(height: 24),
                _buildAdditionalInfoCard(context, explanation, localizations),
              ],
              const SizedBox(height: 32),
              _buildActionButtons(context, localizations),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    explanation,
    AppLocalizations localizations,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.result,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    explanation.result,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 42,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputsCard(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.input_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                localizations.inputs,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.inputs.asMap().entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(
                  entry.value.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationSection(
    BuildContext context,
    explanation,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.08),
                AppColors.primary.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.explanation,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${explanation.steps.length} ${localizations.steps}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          explanation.steps.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExplanationStepWidget(
              step: explanation.steps[index],
              stepNumber: index + 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoCard(
    BuildContext context,
    explanation,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.info.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tips_and_updates_rounded,
              color: AppColors.info,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.usefulTip,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation.additionalInfo!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: CustomButton(
                  text: _isSaved
                      ? localizations.savedSuccessfully
                      : localizations.saveToHistory,
                  icon: _isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  onPressed: _isSaved ? null : () => _saveToHistory(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: localizations.home,
          icon: Icons.home_rounded,
          isOutlined: true,
          onPressed: () => context.go('/'),
        ),
      ],
    );
  }

  Future<void> _saveToHistory(BuildContext context) async {
    final explanation = MathHelper.calculate(
      widget.operationType,
      widget.inputs,
    );
    final localizations = AppLocalizations.of(context);
    final explanationJson = jsonEncode(explanation.toMap());
    final inputText = widget.inputs.join(' , ');

    // حفظ مفتاح الترجمة بدلاً من النص المترجم
    await ref
        .read(historyProvider.notifier)
        .addToHistory(
          level: widget.level,
          operationType: widget.operationType.translationKey,
          input: inputText,
          result: explanation.result,
          explanation: explanationJson,
        );

    if (context.mounted) {
      setState(() => _isSaved = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(localizations.savedToHistory),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _copyResult(
    BuildContext context,
    explanation,
    AppLocalizations localizations,
  ) {
    final text =
        '''
${localizations.result}: ${explanation.result}

${localizations.explanation}:
${explanation.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value.title}\n   ${e.value.description}').join('\n\n')}
''';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.copy, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(localizations.copiedToClipboard),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareResult(
    BuildContext context,
    explanation,
    AppLocalizations localizations,
  ) {
    _copyResult(context, explanation, localizations);
  }
}
