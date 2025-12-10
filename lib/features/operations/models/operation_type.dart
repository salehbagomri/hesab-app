import 'package:flutter/material.dart';

/// نوع العملية الحسابية
enum OperationType {
  // المستوى الإعدادي
  addition,
  subtraction,
  multiplication,
  division,
  fractions,
  percentages,

  // المستوى المتوسط
  linearEquations,
  squareRoots,
  powers,
  areas,
  ratios,
  average,

  // المستوى الثانوي
  quadraticEquations,
  trigonometry,
  logarithms,
  matrices,
  sequences,
  probability,
}

extension OperationTypeExtension on OperationType {
  /// المستوى الذي تنتمي إليه العملية
  String get level {
    switch (this) {
      case OperationType.addition:
      case OperationType.subtraction:
      case OperationType.multiplication:
      case OperationType.division:
      case OperationType.fractions:
      case OperationType.percentages:
        return 'elementary';

      case OperationType.linearEquations:
      case OperationType.squareRoots:
      case OperationType.powers:
      case OperationType.areas:
      case OperationType.ratios:
      case OperationType.average:
        return 'middle';

      case OperationType.quadraticEquations:
      case OperationType.trigonometry:
      case OperationType.logarithms:
      case OperationType.matrices:
      case OperationType.sequences:
      case OperationType.probability:
        return 'high';
    }
  }

  /// مفتاح الترجمة
  String get translationKey {
    return name;
  }

  /// الأيقونة
  IconData get icon {
    switch (this) {
      case OperationType.addition:
        return Icons.add_circle_outline;
      case OperationType.subtraction:
        return Icons.remove_circle_outline;
      case OperationType.multiplication:
        return Icons.close;
      case OperationType.division:
        return Icons.percent;
      case OperationType.fractions:
        return Icons.pie_chart_outline;
      case OperationType.percentages:
        return Icons.trending_up;

      case OperationType.linearEquations:
        return Icons.functions;
      case OperationType.squareRoots:
        return Icons.square_foot;
      case OperationType.powers:
        return Icons.superscript;
      case OperationType.areas:
        return Icons.crop_square;
      case OperationType.ratios:
        return Icons.compare_arrows;
      case OperationType.average:
        return Icons.analytics_outlined;

      case OperationType.quadraticEquations:
        return Icons.functions;
      case OperationType.trigonometry:
        return Icons.timeline;
      case OperationType.logarithms:
        return Icons.auto_graph;
      case OperationType.matrices:
        return Icons.grid_on;
      case OperationType.sequences:
        return Icons.linear_scale;
      case OperationType.probability:
        return Icons.casino_outlined;
    }
  }

  /// عدد حقول الإدخال المطلوبة
  int get inputCount {
    switch (this) {
      case OperationType.addition:
      case OperationType.subtraction:
      case OperationType.multiplication:
      case OperationType.division:
      case OperationType.percentages:
      case OperationType.powers:
      case OperationType.ratios:
      case OperationType.average:
        return 2;

      case OperationType.fractions:
        return 4; // بسط1، مقام1، بسط2، مقام2

      case OperationType.squareRoots:
        return 1;

      case OperationType.linearEquations:
        return 2; // a و b في x + a = b

      case OperationType.areas:
        return 2; // الطول والعرض (إذا كان المربع، العرض = 0)

      case OperationType.quadraticEquations:
        return 3; // a, b, c في ax² + bx + c = 0

      case OperationType.trigonometry:
        return 1; // الزاوية بالدرجات

      case OperationType.logarithms:
        return 2; // العدد والأساس

      case OperationType.sequences:
        return 3; // الحد الأول، الأساس، عدد الحدود

      case OperationType.probability:
        return 2; // النتائج المرغوبة، إجمالي النتائج

      case OperationType.matrices:
        return 4; // سيتم تحسينه لاحقاً
    }
  }

  /// الحصول على تسمية حقل الإدخال بناءً على اللغة
  String getInputLabel(int index, dynamic localizations) {
    switch (this) {
      case OperationType.addition:
      case OperationType.subtraction:
      case OperationType.multiplication:
      case OperationType.division:
        return index == 0
            ? localizations.firstNumber
            : localizations.secondNumber;

      case OperationType.fractions:
        final labels = [
          localizations.firstNumerator,
          localizations.firstDenominator,
          localizations.secondNumerator,
          localizations.secondDenominator,
        ];
        return labels[index];

      case OperationType.percentages:
        return index == 0
            ? localizations.percentage
            : localizations.numberValue;

      case OperationType.powers:
        return index == 0 ? localizations.base : localizations.exponent;

      case OperationType.squareRoots:
        return localizations.numberValue;

      case OperationType.linearEquations:
        return index == 0 ? localizations.valueA : localizations.valueB;

      case OperationType.ratios:
      case OperationType.average:
        return index == 0
            ? localizations.firstNumber
            : localizations.secondNumber;

      case OperationType.areas:
        return index == 0
            ? localizations.lengthOrSide
            : localizations.widthOrZero;

      case OperationType.quadraticEquations:
        final labels = [
          localizations.coefficientA,
          localizations.coefficientB,
          localizations.constantC,
        ];
        return labels[index];

      case OperationType.trigonometry:
        return localizations.angleInDegrees;

      case OperationType.logarithms:
        return index == 0 ? localizations.numberValue : localizations.baseValue;

      case OperationType.sequences:
        final labels = [
          localizations.firstTerm,
          localizations.commonDifference,
          localizations.numberOfTerms,
        ];
        return labels[index];

      case OperationType.probability:
        return index == 0
            ? localizations.favorableOutcomes
            : localizations.totalOutcomes;

      case OperationType.matrices:
        return index == 0
            ? localizations.value1
            : index == 1
            ? localizations.value2
            : index == 2
            ? localizations.value3
            : localizations.value4;
    }
  }
}
