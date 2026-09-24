import 'package:salapify/core/services/push_notification_service.dart';
import 'package:salapify/core/services/sync_trigger_service.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/theme/app_theme.dart';
import 'package:salapify/core/theme/theme_controller.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/settings/data/services/settings_sync_service.dart';
import 'package:salapify/features/premium/data/services/entitlement_sync_service.dart';
import 'package:salapify/firebase_options.dart';
import 'package:salapify/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/premium/data/services/purchase_service.dart';
import 'package:salapify/core/widgets/global_loading.dart';
import 'core/lifecycle/period_reset_lifecycle_observer.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  tz_data.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize(
    serverClientId:
        '1017841458128-psiglpuppigqrakhe4qfkmjnvjnd58a0.apps.googleusercontent.com',
  );

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme_mode');
  final initialThemeMode = savedTheme == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(
    ProviderScope(
      overrides: [
        themeControllerProvider.overrideWith(
          () => ThemeController(initialThemeMode),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runStartupSync();
      // Fire-and-forget: warms PurchaseService's cached price so the upsell sheet doesn't show a stale hardcoded value on first tap.
      ref.read(purchaseServiceProvider).premiumPriceLabel();
    });
  }

  Future<void> _runStartupSync() async {
    final pushService = ref.read(pushNotificationServiceProvider);
    await pushService.ensureLocalNotificationsInitialized();
    if (!mounted) return;

    final remindersEnabled = await ref.read(
      reminderNotificationsSettingProvider.future,
    );
    if (!mounted) return;

    if (remindersEnabled) {
      final alreadyGranted = await pushService.hasNotificationPermission();
      if (!mounted) return;
      if (alreadyGranted) {
        await pushService.scheduleMonthlyReminders();
        if (!mounted) return;
      }
    }

    final user = await ref.read(authStateChangesProvider.future);
    if (!mounted) return;

    final uid = user?.uid;
    if (uid == null) return; // guest mode, nothing to sync

    try {
  await Future.wait([
    () async {
      final syncService = ref.read(budgetSyncServiceProvider);
      await syncService.pullRemoteCategories(uid);
      await syncService.pushUnsyncedCategories(uid);
    }().catchError((e) {
      if (mounted) {
        _logIfRealError(e, context: 'startupSync: budget pull/push');
      }
    }),
    () async {
      final settingsService = ref.read(settingsSyncServiceProvider);
      await settingsService.pullRemoteSettings(uid);
      await settingsService.retryPendingSettingsSync(uid);
    }().catchError((e) {
      if (mounted) {
        _logIfRealError(e, context: 'startupSync: settings pull/retry');
      }
    }),
    () async {
      final entitlementService = ref.read(entitlementSyncServiceProvider);
      await entitlementService.pullRemoteEntitlement(uid);
    }().catchError((e) {
      if (mounted) {
        _logIfRealError(e, context: 'startupSync: entitlement pull');
      }
    }),
  ]);
} finally {
      if (mounted) {
        ref.invalidate(budgetingPeriodSettingProvider);
        ref.invalidate(firstHalfEndDaySettingProvider);
        ref.invalidate(currencySettingProvider);
      }
    }

    if (!mounted) return;

    await ref.read(pushNotificationServiceProvider).initForUser(uid);
  }

  void _logIfRealError(Object e, {required String context}) {
    final isOnline = ref.read(isOnlineProvider).value ?? true;
    if (!isOnline) return; // expected — offline, will retry later
    // debugPrint('[StartupSync] REAL ERROR in $context: $e');
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(syncTriggerProvider);

    return PeriodResetLifecycleObserver(
      child: MaterialApp.router(
        routerConfig: ref.watch(goRouterProvider),
        title: 'Salapify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ref.watch(themeControllerProvider),
        builder: (context, child) {
          final colors = Theme.of(context).extension<AppColorsExt>()!;
          return GlobalLoadingOverlay(
            child: Container(
              decoration: BoxDecoration(gradient: colors.backgroundGradient),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
