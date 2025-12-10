import 'package:hive/hive.dart';

part 'history_item.g.dart';

/// Model لحفظ سجل العمليات في قاعدة البيانات المحلية
@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String level; // 'elementary', 'middle', 'high'

  @HiveField(2)
  late String operationType; // 'addition', 'subtraction', etc.

  @HiveField(3)
  late String input; // '12 + 25'

  @HiveField(4)
  late String result; // '37'

  @HiveField(5)
  late String explanation; // JSON string

  @HiveField(6)
  late DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.level,
    required this.operationType,
    required this.input,
    required this.result,
    required this.explanation,
    required this.timestamp,
  });

  /// تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'operationType': operationType,
      'input': input,
      'result': result,
      'explanation': explanation,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// إنشاء من Map
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as int,
      level: map['level'] as String,
      operationType: map['operationType'] as String,
      input: map['input'] as String,
      result: map['result'] as String,
      explanation: map['explanation'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'HistoryItem(id: $id, level: $level, operationType: $operationType, input: $input, result: $result, timestamp: $timestamp)';
  }
}
