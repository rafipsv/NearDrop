import 'package:go_router/go_router.dart';

import '../../features/discovery/presentation/pages/home_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/splash_page.dart';
import '../../features/transfer/presentation/pages/file_picker_page.dart';
import '../../features/transfer/presentation/pages/qr_scan_page.dart';
import '../../features/transfer/presentation/pages/qr_send_page.dart';
import '../../features/transfer/presentation/pages/transfer_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.files,
        builder: (context, state) => const FilePickerPage(),
      ),
      GoRoute(
        path: AppRoutes.transfer,
        builder: (context, state) => const TransferPage(),
      ),
      GoRoute(
        path: AppRoutes.qrSend,
        builder: (context, state) => const QrSendPage(),
      ),
      GoRoute(
        path: AppRoutes.qrScan,
        builder: (context, state) => const QrScanPage(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
