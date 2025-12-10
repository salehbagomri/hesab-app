import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../localization/app_localizations.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/history/screens/history_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/operations/screens/operations_list_screen.dart';
import '../../features/operations/screens/operation_input_screen.dart';
import '../../features/operations/screens/result_screen.dart';
import '../../features/operations/models/operation_type.dart';
import '../../features/operations/models/explanation.dart';
import '../../features/history/models/history_item.dart';

/// Router الرئيسي للتطبيق باستخدام GoRouter
class AppRouter {
  AppRouter._();

  /// مسارات التطبيق
  static const String home = '/';
  static const String history = '/history';
  static const String historyDetail = '/history-detail';
  static const String settings = '/settings';
  static const String operations = '/operations';
  static const String operationInput = '/operation-input';
  static const String result = '/result';

  /// GoRouter Configuration
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) =>
            _buildPageWithFadeTransition(context, state, const HomeScreen()),
      ),
      GoRoute(
        path: history,
        name: 'history',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const HistoryScreen(),
        ),
      ),
      GoRoute(
        path: historyDetail,
        name: 'historyDetail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return _buildPageWithSlideTransition(
            context,
            state,
            HistoryDetailScreen(
              item: extra['item'] as HistoryItem,
              explanation: extra['explanation'] as Explanation,
            ),
          );
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/operations/:levelId',
        name: 'operations',
        builder: (context, state) {
          final levelId = state.pathParameters['levelId']!;
          return OperationsListScreen(levelId: levelId);
        },
      ),
      GoRoute(
        path: operationInput,
        name: 'operationInput',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OperationInputScreen(
            operationType: extra['operationType'] as OperationType,
            level: extra['level'] as String,
          );
        },
      ),
      GoRoute(
        path: result,
        name: 'result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ResultScreen(
            operationType: extra['operationType'] as OperationType,
            inputs: extra['inputs'] as List<double>,
            level: extra['level'] as String,
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      final localizations = AppLocalizations.of(context);
      return Scaffold(
        body: Center(
          child: Text('${localizations.pageNotFound}\n${state.uri}'),
        ),
      );
    },
  );

  /// بناء صفحة مع انتقال fade
  static Page _buildPageWithFadeTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// بناء صفحة مع انتقال slide
  static Page _buildPageWithSlideTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
