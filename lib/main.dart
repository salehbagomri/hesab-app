import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'features/history/models/history_item.dart';
import 'features/settings/models/settings.dart';
import 'core/constants/app_constants.dart';

void main() async {
  // تأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // تسجيل Adapters
  Hive.registerAdapter(HistoryItemAdapter());
  Hive.registerAdapter(SettingsAdapter());

  // فتح Boxes
  await Hive.openBox<HistoryItem>(AppConstants.historyBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);

  // تشغيل التطبيق مع Riverpod
  runApp(const ProviderScope(child: HesabApp()));
}
