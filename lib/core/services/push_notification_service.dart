import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/shell/presentation/screens/home_screen.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:salapify/router/routes.dart';
import 'dart:async';

part 'push_notification_service.g.dart';

class PushNotificationService {
  PushNotificationService(this._messaging, this._userRepository, this._ref);
  final FirebaseMessaging _messaging;
  final UserRepository _userRepository;
  final Ref _ref;

  final _localNotifications = FlutterLocalNotificationsPlugin();

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedSub;
  StreamSubscription<String>? _onTokenSub;

  String? _initializedUid;
  String? _initInFlightUid;
  Future<void>? _initInFlight;
  String? _savedToken; // last token saved this session, fallback for removal
  int _generation = 0;

  bool _localInitialized = false;

  static const _channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'Chat, bill activity, and payment updates',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('message_tone'),
    playSound: true,
  );

  static const _reminderChannel = AndroidNotificationChannel(
    'reminders_channel',
    'Budget Reminders',
    description: 'Monthly nudges to update your budget',
    importance: Importance.defaultImportance,
  );

  static const _reminderIds = [1001, 1002];

  Future<void> initForUser(String uid) {
    // Session switched users without clearForUser (disabled/revoked account).
    if ((_initializedUid != null && _initializedUid != uid) ||
        (_initInFlightUid != null && _initInFlightUid != uid)) {
      _generation++;
      _initializedUid = null;
      _initInFlight = null;
      _initInFlightUid = null;
    }

    if (_initializedUid == uid) return Future.value();
    final inFlight = _initInFlight;
    if (inFlight != null && _initInFlightUid == uid) return inFlight;

    late final Future<void> future;
    future = _initForUser(uid).whenComplete(() {
      if (identical(_initInFlight, future)) {
        _initInFlight = null;
        _initInFlightUid = null;
      }
    });
    _initInFlight = future;
    _initInFlightUid = uid;
    return future;
  }

  Future<void> _initForUser(String uid) async {
    final gen = _generation;
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      await ensureLocalNotificationsInitialized();
      if (gen != _generation) return;

      _listenForForegroundMessages();
      _listenForNotificationTaps();

      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 10),
      );
      if (gen != _generation || token == null) return;

      await _userRepository.saveFcmToken(uid, token);
      if (gen != _generation) return;
      _savedToken = token;

      await _onTokenSub?.cancel();
      if (gen != _generation) return;
      _onTokenSub = _messaging.onTokenRefresh.listen((t) async {
        try {
          await _userRepository.saveFcmToken(uid, t);
          _savedToken = t;
        } catch (_) {}
      });

      // Marked done only after full success, so failures retry next time.
      _initializedUid = uid;
    } catch (_) {
      // FCM unavailable: local reminders and the in-app list still work.
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('ic_notification');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handles taps while app is in foreground/background but still alive
        final groupId = response.payload;
        if (groupId != null) _navigateToGroup(groupId);
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_reminderChannel);
  }

  void _listenForForegroundMessages() {
    _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('message_tone'),
            playSound: true,
          ),
        ),
        payload:
            message.data['groupId'], // carried through to the tap handler above
      );
    });
  }

  void _listenForNotificationTaps() {
    _onOpenedSub?.cancel();
    _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final groupId = message.data['groupId'];
      if (groupId != null) _navigateToGroup(groupId);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      final groupId = message?.data['groupId'];
      if (groupId != null) _navigateToGroup(groupId);
    });
  }

  void _navigateToGroup(String groupId) {
    final router = _ref.read(goRouterProvider);
    _ref.read(homeTabIndexProvider.notifier).state = 2;
    router.go('/home');
    router.pushNamed(
      AppRoutes.splitGroupDetail.name,
      pathParameters: {'groupId': groupId},
    );
  }

  Future<void> clearForUser(String uid) async {
    _generation++; 
    _initInFlight = null;
    _initInFlightUid = null;

    await _onTokenSub?.cancel(); // stop refresh-triggered saves
    _onTokenSub = null;

    String? token;
    try {
      token = await _messaging.getToken().timeout(const Duration(seconds: 3));
    } catch (_) {}

    final saved = _savedToken;
    try {
      for (final t in {if (token != null) token, if (saved != null) saved}) {
        await _userRepository.removeFcmToken(uid, t);
      }
      _savedToken = null;
    } catch (_) {
      _initializedUid = null;
      unawaited(initForUser(uid));
      rethrow;
    }

    await _onMessageSub?.cancel();
    await _onOpenedSub?.cancel();
    _onMessageSub = _onOpenedSub = null;
    _initializedUid = null;
  }

  Future<void> ensureLocalNotificationsInitialized() async {
    if (_localInitialized) return;
    await _setupLocalNotifications();
    _localInitialized = true;
  }

  Future<void> scheduleMonthlyReminders() async {
    await _scheduleMonthly(
      id: 1001,
      day: 1,
      title: 'New month, fresh budget 📊',
      body: 'Update your budget and log any pending transactions.',
    );
    await _scheduleMonthly(
      id: 1002,
      day: 15, // was 16
      title: 'Midmonth check-in 💸',
      body: "Don't forget to log your recent expenses.",
    );
  }

  Future<void> cancelMonthlyReminders() async {
    await ensureLocalNotificationsInitialized();
    for (final id in _reminderIds) {
      await _localNotifications.cancel(id: id);
    }
  }

  Future<void> _scheduleMonthly({
    required int id,
    required int day,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, day, 9, 0);
    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(tz.local, now.year, now.month + 1, day, 9, 0);
    }

    await _localNotifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled, // was positional, now named
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannel.id,
          _reminderChannel.name,
          channelDescription: _reminderChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<bool> requestLocalNotificationPermission() async {
    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return true;

    final granted = await androidImpl.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<bool> hasNotificationPermission() async {
    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return true;

    final enabled = await androidImpl.areNotificationsEnabled();
    return enabled ?? false;
  }
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationService(
    FirebaseMessaging.instance,
    ref.watch(userRepositoryProvider),
    ref,
  );
}
