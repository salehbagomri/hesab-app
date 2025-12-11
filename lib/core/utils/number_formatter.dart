/// أداة تنسيق الأرقام - إزالة الأصفار غير الضرورية
class NumberFormatter {
  NumberFormatter._();

  /// تنسيق الرقم لإزالة .0 إذا كان عدد صحيح
  /// مثال: 6.0 -> "6" , 6.2 -> "6.2"
  static String format(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toString();
  }

  /// تنسيق الرقم مع عدد محدد من المنازل العشرية
  /// يزيل الأصفار غير الضرورية في النهاية
  static String formatWithPrecision(double number, int decimalPlaces) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    String formatted = number.toStringAsFixed(decimalPlaces);
    // إزالة الأصفار الزائدة من النهاية
    formatted = formatted.replaceAll(RegExp(r'\.?0+$'), '');

    return formatted;
  }

  /// تنسيق قائمة من الأرقام
  static String formatList(List<double> numbers) {
    return numbers.map((n) => format(n)).join(' , ');
  }
}
