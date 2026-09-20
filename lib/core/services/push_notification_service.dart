import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/shell/presentation/screens/home_screen.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:salapify/router/routes.dart';

part 'push_notification_service.g.dart';

class PushNotificationService {
  PushNotificationService(this._messaging, this._userRepository, this._ref);
  final FirebaseMessaging _messaging;
  final UserRepository _userRepository;
  final Ref _ref;

  final _localNotifications = FlutterLocalNotificationsPlugin();

  bool _localInitialized = false;

  static const _channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'Chat, bill activity, and payment updates',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('message_tone'),
    playSound: true,
  );

  static const _reminderIds = [1001, 1002];

  Future<void> initForUser(String uid) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await ensureLocalNotificationsInitialized();
    _listenForForegroundMessages();
    _listenForNotificationTaps();

    final token = await _messaging.getToken();
    if (token != null) {
      await _userRepository.saveFcmToken(uid, token);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      _userRepository.saveFcmToken(uid, newToken);
    });
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
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
  }

  void _listenForForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
    // App was backgrounded (not killed) when tapped
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final groupId = message.data['groupId'];
      if (groupId != null) _navigateToGroup(groupId);
    });

    // App was fully killed, opened via notification tap
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
    final token = await _messaging.getToken();
    if (token != null) {
      await _userRepository.removeFcmToken(uid, token);
    }
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
      day: 16,
      title: 'Midmonth check-in 💸',
      body: "Don't forget to log your recent expenses.",
    );
  }

  Future<void> cancelMonthlyReminders() async {
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
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
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
