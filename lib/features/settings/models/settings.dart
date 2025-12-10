import 'package:hive/hive.dart';

part 'settings.g.dart';

/// Model لإعدادات التطبيق
@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  late String language; // 'ar' or 'en'

  @HiveField(1)
  late bool isDarkMode;

  @HiveField(2)
  late bool showAnimations;

  Settings({
    this.language = 'ar',
    this.isDarkMode = false,
    this.showAnimations = true,
  });

  /// نسخ مع تغييرات
  Settings copyWith({
    String? language,
    bool? isDarkMode,
    bool? showAnimations,
  }) {
    return Settings(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showAnimations: showAnimations ?? this.showAnimations,
    );
  }

  /// تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'isDarkMode': isDarkMode,
      'showAnimations': showAnimations,
    };
  }

  /// إنشاء من Map
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      language: map['language'] ?? 'ar',
      isDarkMode: map['isDarkMode'] ?? false,
      showAnimations: map['showAnimations'] ?? true,
    );
  }
}
