import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../models/history_item.dart';

/// Provider لإدارة سجل العمليات الحسابية
final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryItem>>((ref) {
      return HistoryNotifier();
    });

class HistoryNotifier extends StateNotifier<List<HistoryItem>> {
  HistoryNotifier() : super([]) {
    _loadHistory();
  }

  Box<HistoryItem>? _historyBox;
  int _nextId = 0; // عداد للـ IDs

  /// تحميل السجل من Hive
  void _loadHistory() {
    try {
      // استخدام Box المفتوح بالفعل في main.dart
      _historyBox = Hive.box<HistoryItem>(AppConstants.historyBoxName);
      state = _historyBox!.values.toList().reversed.toList(); // الأحدث أولاً

      // تحديد آخر ID مستخدم
      if (state.isNotEmpty) {
        _nextId =
            state.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    } catch (e) {
      print('خطأ في تحميل السجل: $e');
      state = [];
    }
  }

  /// إضافة عملية جديدة للسجل
  Future<void> addToHistory({
    required String level,
    required String operationType,
    required String input,
    required String result,
    required String explanation,
  }) async {
    try {
      if (_historyBox == null) {
        _loadHistory();
      }

      final id = _nextId++; // استخدام عداد بسيط
      final item = HistoryItem(
        id: id,
        level: level,
        operationType: operationType,
        input: input,
        result: result,
        explanation: explanation,
        timestamp: DateTime.now(),
      );

      await _historyBox!.put(id, item);
      state = [item, ...state]; // إضافة في البداية
      print('تم حفظ العملية بنجاح - ID: $id');
    } catch (e) {
      print('خطأ في حفظ العملية: $e');
    }
  }

  /// حذف عنصر من السجل
  Future<void> deleteItem(int id) async {
    try {
      if (_historyBox == null) {
        _loadHistory();
      }
      await _historyBox?.delete(id);
      state = state.where((item) => item.id != id).toList();
      print('تم حذف العملية - ID: $id');
    } catch (e) {
      print('خطأ في حذف العملية: $e');
    }
  }

  /// حذف كل السجل
  Future<void> clearHistory() async {
    try {
      if (_historyBox == null) {
        _loadHistory();
      }
      await _historyBox?.clear();
      state = [];
      print('تم حذف جميع العمليات من السجل');
    } catch (e) {
      print('خطأ في حذف السجل: $e');
    }
  }

  /// البحث في السجل
  List<HistoryItem> searchHistory(String query) {
    if (query.isEmpty) return state;

    return state.where((item) {
      return item.input.contains(query) ||
          item.result.contains(query) ||
          item.operationType.contains(query);
    }).toList();
  }

  /// فلترة حسب المستوى
  List<HistoryItem> filterByLevel(String level) {
    if (level.isEmpty) return state;
    return state.where((item) => item.level == level).toList();
  }

  /// فلترة حسب نوع العملية
  List<HistoryItem> filterByOperation(String operationType) {
    if (operationType.isEmpty) return state;
    return state.where((item) => item.operationType == operationType).toList();
  }

  /// الحصول على آخر العمليات (للشاشة الرئيسية)
  List<HistoryItem> getRecentOperations({int limit = 5}) {
    return state.take(limit).toList();
  }
}
