import 'package:salapify/core/services/sync_trigger_service.dart';
import 'package:salapify/core/theme/app_theme.dart';
import 'package:salapify/core/theme/theme_controller.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/firebase_options.dart';
import 'package:salapify/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
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
    // Run once at startup, after first frame, so ref is safe to use.
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupSync());
  }

  Future<void> _runStartupSync() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return; // guest at startup — nothing to sync

    try {
      final syncService = ref.read(budgetSyncServiceProvider);
      await syncService.pullRemoteCategories(uid);
      await syncService.pushUnsyncedCategories(uid);
    } catch (_) {
      // Offline at startup — connectivity listener will catch up later.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the connectivity-triggered sync listener alive for the whole session.
    ref.watch(syncTriggerProvider);

    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: 'Salapify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),
    );
  }
}