import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../models/settings.dart';

/// Provider لإدارة إعدادات التطبيق
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((
  ref,
) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    _loadSettings();
  }

  Box? _settingsBox;
  static const String _settingsKey = 'app_settings';

  /// تحميل الإعدادات من Hive
  void _loadSettings() {
    try {
      _settingsBox = Hive.box(AppConstants.settingsBoxName);
      final savedSettings = _settingsBox?.get(_settingsKey);

      if (savedSettings != null && savedSettings is Settings) {
        state = savedSettings;
      } else {
        // إعدادات افتراضية
        state = Settings(
          language: 'ar',
          isDarkMode: false,
          showAnimations: true,
        );
        _saveSettings();
      }
      print('تم تحميل الإعدادات: ${state.toMap()}');
    } catch (e) {
      print('خطأ في تحميل الإعدادات: $e');
      state = Settings();
    }
  }

  /// حفظ الإعدادات في Hive
  Future<void> _saveSettings() async {
    try {
      await _settingsBox?.put(_settingsKey, state);
      print('تم حفظ الإعدادات: ${state.toMap()}');
    } catch (e) {
      print('خطأ في حفظ الإعدادات: $e');
    }
  }

  /// تغيير اللغة
  Future<void> changeLanguage(String language) async {
    state = state.copyWith(language: language);
    await _saveSettings();
  }

  /// تبديل الوضع الليلي
  Future<void> toggleDarkMode() async {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    await _saveSettings();
  }

  /// تبديل الرسوم المتحركة
  Future<void> toggleAnimations() async {
    state = state.copyWith(showAnimations: !state.showAnimations);
    await _saveSettings();
  }

  /// إعادة تعيين الإعدادات للافتراضية
  Future<void> resetToDefaults() async {
    state = Settings();
    await _saveSettings();
  }
}
