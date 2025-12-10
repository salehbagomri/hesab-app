import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../models/operation_type.dart';

/// شاشة إدخال البيانات للعملية الحسابية
class OperationInputScreen extends StatefulWidget {
  final OperationType operationType;
  final String level;

  const OperationInputScreen({
    super.key,
    required this.operationType,
    required this.level,
  });

  @override
  State<OperationInputScreen> createState() => _OperationInputScreenState();
}

class _OperationInputScreenState extends State<OperationInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    // إنشاء controllers حسب عدد الحقول المطلوبة
    final inputCount = widget.operationType.inputCount;
    for (int i = 0; i < inputCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: localizations.translate(widget.operationType.translationKey),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // أيقونة العملية
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  widget.operationType.icon,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // عنوان العملية
            Center(
              child: Text(
                localizations.translate(widget.operationType.translationKey),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // حقول الإدخال
            ...List.generate(
              widget.operationType.inputCount,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _controllers[index],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: InputDecoration(
                    labelText: widget.operationType.getInputLabel(
                      index,
                      localizations,
                    ),
                    hintText: localizations.enterANumber,
                    prefixIcon: Icon(Icons.dialpad, color: AppColors.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterNumber;
                    }
                    if (double.tryParse(value) == null) {
                      return localizations.pleaseEnterValidNumberFormat;
                    }
                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // زر الحساب
            CustomButton(
              text: localizations.calculate,
              icon: Icons.calculate_rounded,
              isLoading: _isCalculating,
              onPressed: _calculate,
            ),

            const SizedBox(height: 16),

            // معلومات إضافية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizations.detailedExplanationInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCalculating = true);

      // الحصول على القيم المدخلة
      final inputs = _controllers
          .map((controller) => double.parse(controller.text))
          .toList();

      // الانتقال إلى شاشة النتيجة
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() => _isCalculating = false);
        context.push(
          '/result',
          extra: {
            'operationType': widget.operationType,
            'inputs': inputs,
            'level': widget.level,
          },
        );
      });
    }
  }
}
