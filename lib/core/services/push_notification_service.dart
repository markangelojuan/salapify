import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/dashboard/presentation/screens/home_screen.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/router/routes.dart';

part 'push_notification_service.g.dart';

class PushNotificationService {
  PushNotificationService(this._messaging, this._userRepository, this._ref);
  final FirebaseMessaging _messaging;
  final UserRepository _userRepository;
  final Ref _ref;

  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'Chat, bill activity, and payment updates',
    importance: Importance.high,
  );

  Future<void> initForUser(String uid) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _setupLocalNotifications();
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
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationService(
    FirebaseMessaging.instance,
    ref.watch(userRepositoryProvider),
    ref,
  );
}
