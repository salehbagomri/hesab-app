import 'dart:math' as math;
import '../../features/operations/models/explanation.dart';
import '../../features/operations/models/operation_type.dart';
import 'number_formatter.dart';

/// مساعد للعمليات الحسابية وتوليد الشرح التفصيلي
class MathHelper {
  MathHelper._();

  /// حساب نتيجة العملية وتوليد الشرح
  static Explanation calculate(OperationType type, List<double> inputs) {
    switch (type) {
      case OperationType.addition:
        return _calculateAddition(inputs[0], inputs[1]);
      case OperationType.subtraction:
        return _calculateSubtraction(inputs[0], inputs[1]);
      case OperationType.multiplication:
        return _calculateMultiplication(inputs[0], inputs[1]);
      case OperationType.division:
        return _calculateDivision(inputs[0], inputs[1]);
      case OperationType.percentages:
        return _calculatePercentage(inputs[0], inputs[1]);
      case OperationType.squareRoots:
        return _calculateSquareRoot(inputs[0]);
      case OperationType.powers:
        return _calculatePower(inputs[0], inputs[1]);
      case OperationType.fractions:
        return _calculateFractions(
          inputs[0],
          inputs[1],
          inputs.length > 2 ? inputs[2] : 0,
          inputs.length > 3 ? inputs[3] : 0,
        );
      case OperationType.linearEquations:
        return _calculateLinearEquation(inputs[0], inputs[1]);
      case OperationType.average:
        return _calculateAverage(inputs);
      case OperationType.ratios:
        return _calculateRatio(inputs[0], inputs[1]);
      case OperationType.areas:
        return _calculateArea(inputs[0], inputs.length > 1 ? inputs[1] : 0);
      case OperationType.quadraticEquations:
        return _calculateQuadraticEquation(inputs[0], inputs[1], inputs[2]);
      case OperationType.trigonometry:
        return _calculateTrigonometry(inputs[0]);
      case OperationType.logarithms:
        return _calculateLogarithm(
          inputs[0],
          inputs.length > 1 ? inputs[1] : 10,
        );
      case OperationType.sequences:
        return _calculateSequence(
          inputs[0],
          inputs[1],
          inputs.length > 2 ? inputs[2].toInt() : 5,
        );
      case OperationType.probability:
        return _calculateProbability(inputs[0].toInt(), inputs[1].toInt());
      default:
        return Explanation(
          result: 'expThisFeatureComingSoon',
          steps: [
            ExplanationStep(
              title: 'expSoon',
              description: 'expThisFeatureComingSoon',
            ),
          ],
        );
    }
  }

  /// الجمع مع الشرح
  static Explanation _calculateAddition(double a, double b) {
    final result = a + b;
    final aInt = a.toInt();
    final bInt = b.toInt();

    // تحديد إذا كانت الأرقام صحيحة
    final isInteger = a == aInt && b == bInt;

    if (isInteger && aInt < 1000 && bInt < 1000) {
      // شرح مفصل للأرقام الصحيحة الصغيرة
      return Explanation(
        result: NumberFormatter.formatWithPrecision(result, 0),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $aInt + $bInt',
          ),
          ExplanationStep(
            title: 'expArrangeNumbers',
            description: 'expWriteNumbersAboveEachOther',
            visual: _formatAdditionVisual(aInt, bInt),
          ),
          if (aInt >= 10 || bInt >= 10)
            ExplanationStep(
              title: 'expAddOnes',
              description: _getOnesAddition(aInt, bInt),
            ),
          if (aInt >= 10 || bInt >= 10)
            ExplanationStep(
              title: 'expAddTens',
              description: _getTensAddition(aInt, bInt),
            ),
          ExplanationStep(
            title: 'expFinalResult',
            description: '$aInt + $bInt = ${NumberFormatter.format(result)}',
            isHighlighted: true,
          ),
        ],
      );
    } else {
      // شرح بسيط للأرقام الكبيرة أو العشرية
      return Explanation(
        result: NumberFormatter.format(result),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $a + $b',
          ),
          ExplanationStep(
            title: 'expCalculation',
            description: 'addNumbersDirectly',
          ),
          ExplanationStep(
            title: 'expFinalResult',
            description: '$a + $b = $result',
            isHighlighted: true,
          ),
        ],
      );
    }
  }

  /// الطرح مع الشرح
  static Explanation _calculateSubtraction(double a, double b) {
    final result = a - b;
    final aInt = a.toInt();
    final bInt = b.toInt();
    final isInteger = a == aInt && b == bInt;

    if (isInteger && aInt < 1000 && bInt < 1000) {
      return Explanation(
        result: NumberFormatter.formatWithPrecision(result, 0),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $aInt - $bInt',
          ),
          ExplanationStep(
            title: 'expArrangeNumbers',
            description: 'expWriteNumbersAboveEachOther',
            visual: _formatSubtractionVisual(aInt, bInt),
          ),
          if (aInt >= 10 || bInt >= 10)
            ExplanationStep(
              title: 'expSubtractOnes',
              description: _getOnesSubtraction(aInt, bInt),
            ),
          if (aInt >= 10 || bInt >= 10)
            ExplanationStep(
              title: 'expSubtractTens',
              description: _getTensSubtraction(aInt, bInt),
            ),
          ExplanationStep(
            title: 'expFinalResult',
            description: '$aInt - $bInt = ${NumberFormatter.format(result)}',
            isHighlighted: true,
          ),
        ],
      );
    } else {
      return Explanation(
        result: NumberFormatter.format(result),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $a - $b',
          ),
          ExplanationStep(
            title: 'expCalculation',
            description: 'subtractSecondFromFirst',
          ),
          ExplanationStep(
            title: 'expFinalResult',
            description: '$a - $b = $result',
            isHighlighted: true,
          ),
        ],
      );
    }
  }

  /// الضرب مع الشرح
  static Explanation _calculateMultiplication(double a, double b) {
    final result = a * b;
    final aInt = a.toInt();
    final bInt = b.toInt();
    final isInteger = a == aInt && b == bInt;

    if (isInteger && aInt <= 12 && bInt <= 12) {
      // جدول الضرب البسيط
      return Explanation(
        result: NumberFormatter.formatWithPrecision(result, 0),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $aInt × $bInt',
          ),
          ExplanationStep(
            title: 'expMultiplicationTable',
            description: '$aInt × $bInt = ${NumberFormatter.format(result)}',
          ),
          ExplanationStep(
            title: 'expFinalResult',
            description: 'expTheResult ${NumberFormatter.format(result)}',
            isHighlighted: true,
          ),
        ],
      );
    } else {
      return Explanation(
        result: NumberFormatter.format(result),
        steps: [
          ExplanationStep(
            title: 'expProblem',
            description: 'expWeWantToCalculate $a × $b',
          ),
          ExplanationStep(
            title: 'expMultiply',
            description: 'multiplyTheNumbers',
          ),
          ExplanationStep(
            title: 'expFinalResult',
            description: '$a × $b = $result',
            isHighlighted: true,
          ),
        ],
      );
    }
  }

  /// القسمة مع الشرح
  static Explanation _calculateDivision(double a, double b) {
    if (b == 0) {
      return Explanation(
        result: 'expError',
        steps: [
          ExplanationStep(
            title: 'expError',
            description: 'expCannotDivideByZero',
            isHighlighted: true,
          ),
        ],
        additionalInfo: 'expDivisionByZeroUndefined',
      );
    }

    final result = a / b;
    final remainder = a % b;
    final isExact = remainder == 0;

    return Explanation(
      result: isExact
          ? NumberFormatter.formatWithPrecision(result, 0)
          : NumberFormatter.formatWithPrecision(result, 2),
      steps: [
        ExplanationStep(
          title: 'expProblem',
          description: 'expWeWantToCalculate $a ÷ $b',
        ),
        ExplanationStep(
          title: 'expDivision',
          description: isExact
              ? '$a ÷ $b = ${NumberFormatter.format(result)} (exactDivision)'
              : '$a ÷ $b = ${NumberFormatter.formatWithPrecision(result, 2)}',
        ),
        if (!isExact)
          ExplanationStep(
            title: 'expNote',
            description:
                'remainder = ${NumberFormatter.formatWithPrecision(remainder, 2)}',
          ),
        ExplanationStep(
          title: 'expFinalResult',
          description: isExact
              ? 'expTheResult ${NumberFormatter.format(result)}'
              : 'expTheResult ${NumberFormatter.formatWithPrecision(result, 2)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// النسبة المئوية مع الشرح
  static Explanation _calculatePercentage(double percentage, double number) {
    final result = (percentage / 100) * number;

    return Explanation(
      result: NumberFormatter.formatWithPrecision(result, 2),
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description:
              'نريد حساب: ${NumberFormatter.format(percentage)}% من ${NumberFormatter.format(number)}',
        ),
        ExplanationStep(
          title: '🔢 نحول النسبة المئوية',
          description:
              '${NumberFormatter.format(percentage)}% = ${NumberFormatter.formatWithPrecision(percentage / 100, 2)}',
        ),
        ExplanationStep(
          title: '✖️ نضرب في العدد',
          description:
              '${NumberFormatter.formatWithPrecision(percentage / 100, 2)} × ${NumberFormatter.format(number)} = ${NumberFormatter.formatWithPrecision(result, 2)}',
        ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description:
              '${NumberFormatter.format(percentage)}% من ${NumberFormatter.format(number)} = ${NumberFormatter.formatWithPrecision(result, 2)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// الجذر التربيعي مع الشرح
  static Explanation _calculateSquareRoot(double number) {
    if (number < 0) {
      return Explanation(
        result: 'خطأ',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'لا يمكن حساب الجذر التربيعي لعدد سالب',
            isHighlighted: true,
          ),
        ],
      );
    }

    final result = number.sqrt();
    final isPerfectSquare = result == result.toInt();

    return Explanation(
      result: isPerfectSquare
          ? NumberFormatter.formatWithPrecision(result, 0)
          : NumberFormatter.formatWithPrecision(result, 2),
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description: 'نريد حساب: √${NumberFormatter.format(number)}',
        ),
        ExplanationStep(
          title: '🔢 الجذر التربيعي',
          description: isPerfectSquare
              ? '√${NumberFormatter.format(number)} = ${NumberFormatter.format(result)} (عدد صحيح)'
              : '√${NumberFormatter.format(number)} ≈ ${NumberFormatter.formatWithPrecision(result, 2)}',
        ),
        if (isPerfectSquare)
          ExplanationStep(
            title: '✔️ التحقق',
            description:
                '${NumberFormatter.format(result)} × ${NumberFormatter.format(result)} = ${NumberFormatter.format(number)} ✓',
          ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description: isPerfectSquare
              ? 'الناتج = ${NumberFormatter.format(result)}'
              : 'الناتج ≈ ${NumberFormatter.formatWithPrecision(result, 2)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// الأس مع الشرح
  static Explanation _calculatePower(double base, double exponent) {
    final result = base.pow(exponent);

    return Explanation(
      result: NumberFormatter.format(result),
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description:
              'نريد حساب: ${NumberFormatter.format(base)}^${NumberFormatter.format(exponent)}',
        ),
        if (exponent == 2)
          ExplanationStep(
            title: '🔢 التربيع',
            description:
                '${NumberFormatter.format(base)}² = ${NumberFormatter.format(base)} × ${NumberFormatter.format(base)} = ${NumberFormatter.format(result)}',
          )
        else if (exponent == 3)
          ExplanationStep(
            title: '🔢 التكعيب',
            description:
                '${NumberFormatter.format(base)}³ = ${NumberFormatter.format(base)} × ${NumberFormatter.format(base)} × ${NumberFormatter.format(base)} = ${NumberFormatter.format(result)}',
          )
        else
          ExplanationStep(
            title: '🔢 الحساب',
            description:
                '${NumberFormatter.format(base)}^${NumberFormatter.format(exponent)} = ${NumberFormatter.format(result)}',
          ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description: 'الناتج = $result',
          isHighlighted: true,
        ),
      ],
    );
  }

  // دوال مساعدة للتنسيق
  static String _formatAdditionVisual(int a, int b) {
    return '  $a\n+ $b\n────';
  }

  static String _formatSubtractionVisual(int a, int b) {
    return '  $a\n- $b\n────';
  }

  static String _getOnesAddition(int a, int b) {
    final onesA = a % 10;
    final onesB = b % 10;
    final sum = onesA + onesB;
    return '$onesA + $onesB = $sum';
  }

  static String _getTensAddition(int a, int b) {
    final tensA = a ~/ 10;
    final tensB = b ~/ 10;
    final sum = tensA + tensB;
    return '$tensA + $tensB = $sum';
  }

  static String _getOnesSubtraction(int a, int b) {
    final onesA = a % 10;
    final onesB = b % 10;
    final diff = onesA - onesB;
    return '$onesA - $onesB = $diff';
  }

  static String _getTensSubtraction(int a, int b) {
    final tensA = a ~/ 10;
    final tensB = b ~/ 10;
    final diff = tensA - tensB;
    return '$tensA - $tensB = $diff';
  }

  /// الكسور مع الشرح (جمع كسرين)
  static Explanation _calculateFractions(
    double num1,
    double den1,
    double num2,
    double den2,
  ) {
    if (den1 == 0 || den2 == 0) {
      return Explanation(
        result: 'خطأ',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'المقام لا يمكن أن يكون صفر',
            isHighlighted: true,
          ),
        ],
      );
    }

    // إيجاد المضاعف المشترك الأصغر
    final lcm = _lcm(den1.toInt(), den2.toInt());
    final newNum1 = num1 * (lcm / den1);
    final newNum2 = num2 * (lcm / den2);
    final resultNum = newNum1 + newNum2;

    // تبسيط الكسر
    final gcd = _gcd(resultNum.abs().toInt(), lcm);
    final simplifiedNum = (resultNum / gcd).toInt();
    final simplifiedDen = (lcm / gcd).toInt();

    return Explanation(
      result: simplifiedDen == 1
          ? '$simplifiedNum'
          : '$simplifiedNum/$simplifiedDen',
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description:
              'نريد حساب جمع الكسرين',
          fractionData: {
            'num1': '${num1.toInt()}',
            'den1': '${den1.toInt()}',
            'operator': '+',
            'num2': '${num2.toInt()}',
            'den2': '${den2.toInt()}',
            'resultNum': '$simplifiedNum',
            'resultDen': '$simplifiedDen',
          },
        ),
        ExplanationStep(
          title: '🔢 توحيد المقامات',
          description: 'المضاعف المشترك الأصغر = $lcm',
        ),
        ExplanationStep(
          title: '📊 تحويل الكسور',
          description:
              'نحول الكسرين لنفس المقام ($lcm)',
          visual: '${num1.toInt()}/${den1.toInt()} = ${newNum1.toInt()}/$lcm\n${num2.toInt()}/${den2.toInt()} = ${newNum2.toInt()}/$lcm',
        ),
        ExplanationStep(
          title: '➕ جمع البسوط',
          description:
              '${newNum1.toInt()} + ${newNum2.toInt()} = ${resultNum.toInt()}',
        ),
        if (gcd > 1)
          ExplanationStep(
            title: '✂️ التبسيط',
            description: 'نقسم البسط والمقام على $gcd',
          ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description: simplifiedDen == 1
              ? 'الناتج = $simplifiedNum'
              : 'الناتج = $simplifiedNum/$simplifiedDen',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// المعادلات الخطية البسيطة مع الشرح (x + a = b)
  static Explanation _calculateLinearEquation(double a, double b) {
    final result = b - a;

    return Explanation(
      result: NumberFormatter.format(result),
      steps: [
        ExplanationStep(title: '📝 المعادلة', description: 'x + $a = $b'),
        ExplanationStep(
          title: '🔢 نطرح $a من الطرفين',
          description: 'x + $a - $a = $b - $a',
        ),
        ExplanationStep(title: '📊 التبسيط', description: 'x = ${b - a}'),
        ExplanationStep(
          title: '✔️ التحقق',
          description: 'نعوّض: $result + $a = $b ✓',
        ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description: 'x = $result',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// المتوسط الحسابي مع الشرح
  static Explanation _calculateAverage(List<double> numbers) {
    if (numbers.isEmpty) {
      return Explanation(
        result: 'خطأ',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'لا توجد أرقام لحساب المتوسط',
          ),
        ],
      );
    }

    final sum = numbers.reduce((a, b) => a + b);
    final average = sum / numbers.length;
    final numbersStr = numbers.map((n) => n.toString()).join(' + ');

    return Explanation(
      result: NumberFormatter.formatWithPrecision(average, 2),
      steps: [
        ExplanationStep(
          title: '📝 الأرقام',
          description: 'الأرقام: ${numbers.join(", ")}',
        ),
        ExplanationStep(
          title: '➕ جمع الأرقام',
          description: '$numbersStr = $sum',
        ),
        ExplanationStep(
          title: '➗ القسمة على العدد',
          description: '$sum ÷ ${numbers.length} = $average',
        ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description:
              'المتوسط الحسابي = ${NumberFormatter.formatWithPrecision(average, 2)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// النسبة والتناسب مع الشرح
  static Explanation _calculateRatio(double a, double b) {
    if (b == 0) {
      return Explanation(
        result: 'خطأ',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'لا يمكن حساب النسبة مع صفر',
          ),
        ],
      );
    }

    final gcd = _gcd(a.toInt(), b.toInt());
    final simplifiedA = (a / gcd).toInt();
    final simplifiedB = (b / gcd).toInt();
    final ratio = a / b;

    return Explanation(
      result: '$simplifiedA:$simplifiedB',
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description: 'النسبة بين ${a.toInt()} و ${b.toInt()}',
        ),
        ExplanationStep(
          title: '🔢 القاسم المشترك الأكبر',
          description: 'ق.م.أ = $gcd',
        ),
        ExplanationStep(
          title: '✂️ التبسيط',
          description: '${a.toInt()}÷$gcd : ${b.toInt()}÷$gcd',
        ),
        ExplanationStep(
          title: '📊 النسبة العشرية',
          description:
              '${a.toInt()} ÷ ${b.toInt()} = ${NumberFormatter.formatWithPrecision(ratio, 2)}',
        ),
        ExplanationStep(
          title: '✅ النتيجة النهائية',
          description: 'النسبة = $simplifiedA:$simplifiedB',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// حساب المساحات
  static Explanation _calculateArea(double length, double width) {
    // إذا كان width = 0 فهو مربع
    final isSquare = width == 0 || length == width;
    final area = isSquare ? length * length : length * width;

    if (isSquare) {
      return Explanation(
        result: NumberFormatter.formatWithPrecision(area, 2),
        steps: [
          ExplanationStep(
            title: '📐 نوع الشكل',
            description: 'مربع بطول ضلع = $length',
          ),
          ExplanationStep(
            title: '📝 قانون مساحة المربع',
            description: 'المساحة = الضلع × الضلع = الضلع²',
          ),
          ExplanationStep(
            title: '🔢 التعويض',
            description: 'المساحة = $length × $length',
          ),
          ExplanationStep(
            title: '✅ النتيجة النهائية',
            description:
                'مساحة المربع = ${NumberFormatter.formatWithPrecision(area, 2)} وحدة مربعة',
            isHighlighted: true,
          ),
        ],
      );
    } else {
      return Explanation(
        result: NumberFormatter.formatWithPrecision(area, 2),
        steps: [
          ExplanationStep(
            title: '📐 نوع الشكل',
            description: 'مستطيل بطول = $length وعرض = $width',
          ),
          ExplanationStep(
            title: '📝 قانون مساحة المستطيل',
            description: 'المساحة = الطول × العرض',
          ),
          ExplanationStep(
            title: '🔢 التعويض',
            description: 'المساحة = $length × $width',
          ),
          ExplanationStep(
            title: '✅ النتيجة النهائية',
            description:
                'مساحة المستطيل = ${NumberFormatter.formatWithPrecision(area, 2)} وحدة مربعة',
            isHighlighted: true,
          ),
        ],
      );
    }
  }

  /// حل المعادلة التربيعية ax² + bx + c = 0
  static Explanation _calculateQuadraticEquation(double a, double b, double c) {
    final discriminant = b * b - 4 * a * c;

    if (discriminant < 0) {
      return Explanation(
        result: 'لا يوجد حل حقيقي',
        steps: [
          ExplanationStep(
            title: '📝 المعادلة',
            description: '${a}x² + ${b}x + $c = 0',
          ),
          ExplanationStep(
            title: '🔢 حساب المميز (Δ)',
            description: 'Δ = b² - 4ac = ${b}² - 4(${a})(${c}) = $discriminant',
          ),
          ExplanationStep(
            title: '❌ النتيجة',
            description: 'المميز سالب (Δ < 0)، لذلك لا يوجد حل حقيقي',
            isHighlighted: true,
          ),
        ],
      );
    }

    final sqrtDiscriminant = discriminant.sqrt();
    final x1 = (-b + sqrtDiscriminant) / (2 * a);
    final x2 = (-b - sqrtDiscriminant) / (2 * a);

    return Explanation(
      result: discriminant == 0
          ? 'x = ${x1.toStringAsFixed(2)}'
          : 'x₁ = ${x1.toStringAsFixed(2)}, x₂ = ${x2.toStringAsFixed(2)}',
      steps: [
        ExplanationStep(
          title: '📝 المعادلة',
          description: '${a}x² + ${b}x + $c = 0',
        ),
        ExplanationStep(
          title: '🔢 حساب المميز (Δ)',
          description: 'Δ = b² - 4ac = ${b}² - 4(${a})(${c}) = $discriminant',
        ),
        ExplanationStep(
          title: '📐 الجذر التربيعي للمميز',
          description:
              '√Δ = √$discriminant = ${sqrtDiscriminant.toStringAsFixed(2)}',
        ),
        ExplanationStep(
          title: '🔢 تطبيق القانون',
          description: discriminant == 0
              ? 'x = -b/2a = ${(-b / (2 * a)).toStringAsFixed(2)}'
              : 'x = (-b ± √Δ) / 2a',
        ),
        ExplanationStep(
          title: '✅ الحلول',
          description: discriminant == 0
              ? 'حل واحد: x = ${x1.toStringAsFixed(2)}'
              : 'x₁ = ${x1.toStringAsFixed(2)}\nx₂ = ${x2.toStringAsFixed(2)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// الدوال المثلثية
  static Explanation _calculateTrigonometry(double angleDegrees) {
    final angleRadians = angleDegrees * 3.14159 / 180;
    final sinValue = _sin(angleRadians);
    final cosValue = _cos(angleRadians);
    final tanValue = sinValue / cosValue;

    return Explanation(
      result:
          'sin=${sinValue.toStringAsFixed(3)}, cos=${cosValue.toStringAsFixed(3)}, tan=${tanValue.toStringAsFixed(3)}',
      steps: [
        ExplanationStep(
          title: '📐 الزاوية',
          description: 'الزاوية = $angleDegrees درجة',
        ),
        ExplanationStep(
          title: '🔄 تحويل إلى راديان',
          description:
              'الزاوية بالراديان = $angleDegrees × π/180 = ${angleRadians.toStringAsFixed(3)}',
        ),
        ExplanationStep(
          title: '📊 حساب الجيب (sin)',
          description: 'sin($angleDegrees°) = ${sinValue.toStringAsFixed(3)}',
        ),
        ExplanationStep(
          title: '📊 حساب جيب التمام (cos)',
          description: 'cos($angleDegrees°) = ${cosValue.toStringAsFixed(3)}',
        ),
        ExplanationStep(
          title: '📊 حساب الظل (tan)',
          description:
              'tan($angleDegrees°) = sin/cos = ${tanValue.toStringAsFixed(3)}',
        ),
        ExplanationStep(
          title: '✅ النتيجة',
          description:
              'sin = ${sinValue.toStringAsFixed(3)}\ncos = ${cosValue.toStringAsFixed(3)}\ntan = ${tanValue.toStringAsFixed(3)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// اللوغاريتمات
  static Explanation _calculateLogarithm(double number, double base) {
    if (number <= 0) {
      return Explanation(
        result: 'غير معرف',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'اللوغاريتم غير معرف للأعداد السالبة أو الصفر',
            isHighlighted: true,
          ),
        ],
      );
    }

    // تقريب بسيط للوغاريتم
    final result = _logApprox(number) / _logApprox(base);

    return Explanation(
      result: NumberFormatter.formatWithPrecision(result, 4),
      steps: [
        ExplanationStep(
          title: '📝 المسألة',
          description: 'log_$base($number) = ؟',
        ),
        ExplanationStep(
          title: '📐 القانون',
          description: 'log_b(x) = ln(x) / ln(b)',
        ),
        ExplanationStep(
          title: '🔢 الحساب',
          description: 'log_$base($number) = ln($number) / ln($base)',
        ),
        ExplanationStep(
          title: '✅ النتيجة',
          description:
              'log_$base($number) = ${NumberFormatter.formatWithPrecision(result, 4)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// المتتاليات الحسابية
  static Explanation _calculateSequence(
    double first,
    double difference,
    int terms,
  ) {
    final lastTerm = first + (terms - 1) * difference;
    final sum = (terms * (first + lastTerm)) / 2;

    String sequence = '';
    for (int i = 0; i < terms; i++) {
      final term = first + i * difference;
      sequence += '${term.toStringAsFixed(0)}';
      if (i < terms - 1) sequence += ', ';
    }

    return Explanation(
      result: 'المجموع = ${NumberFormatter.formatWithPrecision(sum, 0)}',
      steps: [
        ExplanationStep(
          title: '📝 معطيات المتتالية',
          description:
              'الحد الأول (a₁) = $first\nأساس المتتالية (d) = $difference\nعدد الحدود (n) = $terms',
        ),
        ExplanationStep(title: '🔢 المتتالية', description: sequence),
        ExplanationStep(
          title: '📐 الحد الأخير',
          description:
              'aₙ = a₁ + (n-1)d = $first + ($terms-1)×$difference = $lastTerm',
        ),
        ExplanationStep(
          title: '📊 قانون المجموع',
          description: 'S = n(a₁ + aₙ)/2',
        ),
        ExplanationStep(
          title: '🔢 التعويض',
          description: 'S = $terms × ($first + $lastTerm) / 2',
        ),
        ExplanationStep(
          title: '✅ النتيجة',
          description:
              'مجموع المتتالية = ${NumberFormatter.formatWithPrecision(sum, 0)}',
          isHighlighted: true,
        ),
      ],
    );
  }

  /// الاحتمالات
  static Explanation _calculateProbability(int favorable, int total) {
    if (total == 0) {
      return Explanation(
        result: 'غير معرف',
        steps: [
          ExplanationStep(
            title: '❌ خطأ',
            description: 'لا يمكن القسمة على صفر',
          ),
        ],
      );
    }

    final probability = favorable / total;
    final percentage = probability * 100;

    return Explanation(
      result:
          '${NumberFormatter.formatWithPrecision(probability, 3)} أو ${NumberFormatter.formatWithPrecision(percentage, 1)}%',
      steps: [
        ExplanationStep(
          title: '📝 المعطيات',
          description:
              'النتائج المرغوبة = $favorable\nإجمالي النتائج الممكنة = $total',
        ),
        ExplanationStep(
          title: '📐 قانون الاحتمال',
          description: 'الاحتمال = عدد النتائج المرغوبة ÷ عدد النتائج الممكنة',
        ),
        ExplanationStep(
          title: '🔢 التعويض',
          description: 'P = $favorable / $total',
        ),
        ExplanationStep(
          title: '✅ النتيجة',
          description:
              'الاحتمال = ${NumberFormatter.formatWithPrecision(probability, 3)}\nبالنسبة المئوية = ${NumberFormatter.formatWithPrecision(percentage, 1)}%',
          isHighlighted: true,
        ),
      ],
    );
  }

  // دوال مساعدة رياضية
  static int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  static int _lcm(int a, int b) {
    return (a * b) ~/ _gcd(a, b);
  }

  // تقريب sin و cos
  static double _sin(double x) {
    // تقريب باستخدام متسلسلة تايلور (حتى 5 حدود)
    double result = x;
    double term = x;
    for (int i = 1; i <= 5; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  static double _cos(double x) {
    // تقريب باستخدام متسلسلة تايلور (حتى 5 حدود)
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 5; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  // تقريب اللوغاريتم الطبيعي
  static double _logApprox(double x) {
    if (x <= 0) return double.nan;
    if (x == 1) return 0;

    // تقريب بسيط باستخدام التكرار
    double result = 0;
    double y = (x - 1) / (x + 1);
    double y2 = y * y;
    double term = y;

    for (int i = 0; i < 10; i++) {
      result += term / (2 * i + 1);
      term *= y2;
    }

    return 2 * result;
  }
}

// Extension methods
extension DoubleExtensions on double {
  double sqrt() => this < 0 ? double.nan : this.pow(0.5);
  double pow(double exponent) => this == 0 && exponent == 0
      ? 1
      : this == 0
      ? 0
      : exponent == 0
      ? 1
      : _customPow(this, exponent);

  static double _customPow(double base, double exponent) {
    if (exponent == exponent.toInt()) {
      // إذا كان الأس عدد صحيح
      double result = 1;
      int exp = exponent.toInt().abs();
      for (int i = 0; i < exp; i++) {
        result *= base;
      }
      return exponent < 0 ? 1 / result : result;
    } else {
      // استخدام dart:math للأسس العشرية
      return math.pow(base, exponent).toDouble();
    }
  }
}
