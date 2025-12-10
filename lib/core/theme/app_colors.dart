import 'package:flutter/material.dart';

/// نظام الألوان النظيف لتطبيق حساب
/// القاعدة: 95% أبيض/رمادي، 5% أزرق
class AppColors {
  AppColors._();

  // اللون الأساسي (استخدام قليل جداً)
  static const Color primary = Color(0xFF1976D2); // أزرق رسمي

  // الخلفيات
  static const Color background = Color(0xFFFFFFFF); // أبيض نقي
  static const Color surface = Color(0xFFF5F5F5); // رمادي فاتح جداً
  static const Color cardBackground = Color(0xFFFFFFFF); // أبيض للبطاقات

  // النصوص
  static const Color textPrimary = Color(0xFF212121); // أسود
  static const Color textSecondary = Color(0xFF757575); // رمادي
  static const Color textTertiary = Color(0xFFBDBDBD); // رمادي فاتح

  // الحالات (عند الحاجة فقط)
  static const Color success = Color(0xFF4CAF50); // أخضر للنتائج الصحيحة
  static const Color error = Color(0xFFF44336); // أحمر للأخطاء
  static const Color warning = Color(0xFFFF9800); // برتقالي للتحذيرات
  static const Color info = Color(0xFF2196F3); // أزرق للمعلومات

  // الحدود
  static const Color border = Color(0xFFE0E0E0); // رمادي خفيف جداً
  static const Color divider = Color(0xFFEEEEEE); // رمادي خفيف للفواصل

  // الظلال
  static const Color shadow = Color(0x0A000000); // ظل خفيف جداً (4% opacity)

  // الشفافيات
  static const Color overlay = Color(0x1A000000); // تراكب خفيف (10% opacity)
}
