/// ثوابت التطبيق
class AppConstants {
  AppConstants._();

  // معلومات التطبيق
  static const String appName = 'حساب';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Hesab Team';

  // Hive Box Names
  static const String historyBoxName = 'history_box';
  static const String settingsBoxName = 'settings_box';

  // المستويات
  static const String levelElementary = 'elementary';
  static const String levelMiddle = 'middle';
  static const String levelHigh = 'high';

  // أنواع العمليات - إعدادي
  static const String opAddition = 'addition';
  static const String opSubtraction = 'subtraction';
  static const String opMultiplication = 'multiplication';
  static const String opDivision = 'division';
  static const String opFractions = 'fractions';
  static const String opPercentages = 'percentages';

  // أنواع العمليات - متوسط
  static const String opLinearEquations = 'linearEquations';
  static const String opSquareRoots = 'squareRoots';
  static const String opPowers = 'powers';
  static const String opAreas = 'areas';
  static const String opRatios = 'ratios';
  static const String opAverage = 'average';

  // أنواع العمليات - ثانوي
  static const String opQuadraticEquations = 'quadraticEquations';
  static const String opTrigonometry = 'trigonometry';
  static const String opLogarithms = 'logarithms';
  static const String opMatrices = 'matrices';
  static const String opSequences = 'sequences';
  static const String opProbability = 'probability';

  // الأبعاد
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // أيقونات المستويات
  static const String iconElementary = '📚';
  static const String iconMiddle = '📐';
  static const String iconHigh = '🎓';
}
