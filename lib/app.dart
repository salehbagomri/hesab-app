import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/localization/app_localizations.dart';
import 'features/settings/providers/settings_provider.dart';

/// التطبيق الرئيسي - حساب
class HesabApp extends ConsumerWidget {
  const HesabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      // معلومات التطبيق
      title: 'حساب',
      debugShowCheckedModeBanner: false,

      // الثيم
      theme: AppTheme.lightTheme,

      // التوطين (متعدد اللغات)
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.language),

      // Router
      routerConfig: AppRouter.router,
    );
  }
}
