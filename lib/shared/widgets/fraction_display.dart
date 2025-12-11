import 'package:flutter/material.dart';

/// Widget لعرض الكسر بشكل عمودي (البسط فوق المقام مع خط فاصل)
class FractionDisplay extends StatelessWidget {
  final String numerator; // البسط
  final String denominator; // المقام
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const FractionDisplay({
    super.key,
    required this.numerator,
    required this.denominator,
    this.fontSize = 20,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.w600,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // البسط (الرقم العلوي)
        Text(numerator, style: textStyle),
        // الخط الفاصل
        Container(
          width: _calculateLineWidth(numerator, denominator, fontSize),
          height: 2,
          color: color ?? Colors.black,
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
        // المقام (الرقم السفلي)
        Text(denominator, style: textStyle),
      ],
    );
  }

  /// حساب عرض الخط الفاصل بناءً على أطول رقم
  double _calculateLineWidth(String num, String den, double size) {
    final maxLength = num.length > den.length ? num.length : den.length;
    return (size * 0.6) * maxLength;
  }
}

/// Widget لعرض معادلة كسور كاملة (كسر + عملية + كسر = نتيجة)
/// يدعم عرض سطر إضافي للتحويلات (مثل: 1/2 = 2/4)
class FractionEquation extends StatelessWidget {
  final String num1;
  final String den1;
  final String operator;
  final String num2;
  final String den2;
  final String resultNum;
  final String resultDen;
  final String? extraLine; // سطر إضافي للتحويلات
  final double fontSize;
  final Color? color;

  const FractionEquation({
    super.key,
    required this.num1,
    required this.den1,
    required this.operator,
    required this.num2,
    required this.den2,
    required this.resultNum,
    required this.resultDen,
    this.extraLine,
    this.fontSize = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // الكسر الأول
            FractionDisplay(
              numerator: num1,
              denominator: den1,
              fontSize: fontSize,
              color: color,
            ),

            // العملية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                operator,
                style: TextStyle(
                  fontSize: fontSize * 1.2,
                  color: color ?? Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // الكسر الثاني
            FractionDisplay(
              numerator: num2,
              denominator: den2,
              fontSize: fontSize,
              color: color,
            ),

            // علامة يساوي والنتيجة إذا كانت موجودة
            if (resultNum.isNotEmpty && resultDen.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '=',
                  style: TextStyle(
                    fontSize: fontSize * 1.2,
                    color: color ?? Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // النتيجة
              FractionDisplay(
                numerator: resultNum,
                denominator: resultDen,
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ],
          ],
        ),

        // السطر الإضافي إن وجد
        if (extraLine != null && extraLine!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              extraLine!,
              style: TextStyle(
                fontSize: fontSize * 0.8,
                color: color ?? Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

/// دالة مساعدة لتحويل نص الكسر من صيغة "5/8" إلى FractionDisplay widget
class FractionFormatter {
  /// تحليل نص الكسر وإرجاع Widget
  static Widget parse(
    String fractionText, {
    double fontSize = 20,
    Color? color,
  }) {
    final parts = fractionText.split('/');
    if (parts.length == 2) {
      return FractionDisplay(
        numerator: parts[0].trim(),
        denominator: parts[1].trim(),
        fontSize: fontSize,
        color: color,
      );
    }
    // إذا لم يكن كسراً، أرجع النص كما هو
    return Text(
      fractionText,
      style: TextStyle(fontSize: fontSize, color: color),
    );
  }

  /// استخراج جميع الكسور من نص وتحويلها إلى عرض مناسب
  static List<InlineSpan> parseInlineText(
    String text, {
    double fontSize = 16,
    Color? color,
  }) {
    final List<InlineSpan> spans = [];
    final RegExp fractionRegex = RegExp(r'(\d+)\s*/\s*(\d+)');

    int lastIndex = 0;
    for (final match in fractionRegex.allMatches(text)) {
      // إضافة النص قبل الكسر
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(fontSize: fontSize, color: color),
          ),
        );
      }

      // إضافة الكسر كـ WidgetSpan
      spans.add(
        WidgetSpan(
          child: FractionDisplay(
            numerator: match.group(1)!,
            denominator: match.group(2)!,
            fontSize: fontSize,
            color: color,
          ),
          alignment: PlaceholderAlignment.middle,
        ),
      );

      lastIndex = match.end;
    }

    // إضافة النص المتبقي
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: TextStyle(fontSize: fontSize, color: color),
        ),
      );
    }

    return spans;
  }
}
