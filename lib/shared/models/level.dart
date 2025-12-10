/// Model لتمثيل مستوى الطالب
class Level {
  final String id;
  final String nameKey; // مفتاح الترجمة
  final String icon;
  final int operationsCount;
  final List<String> operations;

  const Level({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.operationsCount,
    required this.operations,
  });

  /// المستوى الإعدادي
  static const elementary = Level(
    id: 'elementary',
    nameKey: 'elementaryLevel',
    icon: '📚',
    operationsCount: 6,
    operations: [
      'addition',
      'subtraction',
      'multiplication',
      'division',
      'fractions',
      'percentages',
    ],
  );

  /// المستوى المتوسط
  static const middle = Level(
    id: 'middle',
    nameKey: 'middleLevel',
    icon: '📐',
    operationsCount: 6,
    operations: [
      'linearEquations',
      'squareRoots',
      'powers',
      'areas',
      'ratios',
      'average',
    ],
  );

  /// المستوى الثانوي
  static const high = Level(
    id: 'high',
    nameKey: 'highLevel',
    icon: '🎓',
    operationsCount: 6,
    operations: [
      'quadraticEquations',
      'trigonometry',
      'logarithms',
      'matrices',
      'sequences',
      'probability',
    ],
  );

  /// قائمة بجميع المستويات
  static const List<Level> all = [elementary, middle, high];

  /// الحصول على مستوى بواسطة ID
  static Level? getById(String id) {
    try {
      return all.firstWhere((level) => level.id == id);
    } catch (e) {
      return null;
    }
  }
}
