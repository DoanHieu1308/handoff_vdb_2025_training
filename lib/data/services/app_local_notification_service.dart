import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:http/http.dart' as http;
import 'package:handoff_vdb_2025/core/config/notification_config.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';

class AppLocalNotificationService {
  static final AppLocalNotificationService _instance = AppLocalNotificationService._internal();
  factory AppLocalNotificationService() => _instance;
  AppLocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String get _fcmServerKey => dotenv.env['FCM_SERVER_KEY'] ?? '';
  final String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';


  Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await _requestAndroidPermission();
    await _createNotificationChannels();
    await _initializeFCM();
    await _setupConversationListener();
  }

  // Xin quyền POST_NOTIFICATIONS (Android 13+)
  Future<void> _requestAndroidPermission() async {
    final androidImplementation =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >();
    await androidImplementation?.requestNotificationsPermission();
  }

  // Tạo notification channels
  Future<void> _createNotificationChannels() async {
    final androidImplementation =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >();

    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationConfig.chatChannelId,
        NotificationConfig.chatChannelName,
        description: NotificationConfig.chatChannelDescription,
        importance: Importance.max,
        enableVibration: NotificationConfig.enableVibration,
        enableLights: NotificationConfig.enableLights,
        playSound: NotificationConfig.playSound,
        ledColor: Color(NotificationConfig.notificationColor),
        showBadge: true,
      ),
    );

    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationConfig.lifecycleChannelId,
        NotificationConfig.lifecycleChannelName,
        description: NotificationConfig.lifecycleChannelDescription,
        importance: Importance.max,
        enableVibration: NotificationConfig.enableVibration,
        enableLights: NotificationConfig.enableLights,
        playSound: NotificationConfig.playSound,
        ledColor: Color(NotificationConfig.notificationColor),
      ),
    );
  }

  // Hàm show notification cho chat messages
  Future<void> showChatNotification({
    required String title,
    required String message,
    String? senderName,
    String? senderAvatar,
  }) async {
    debugPrint("NotificationService: Bắt đầu tạo notification");
    debugPrint("NotificationService: Title: $title");
    debugPrint("NotificationService: Message: $message");
    debugPrint("NotificationService: Sender: $senderName");

    final androidDetails = AndroidNotificationDetails(
      NotificationConfig.chatChannelId,
      NotificationConfig.chatChannelName,
      channelDescription: NotificationConfig.chatChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: NotificationConfig.enableVibration,
      enableLights: NotificationConfig.enableLights,
      playSound: NotificationConfig.playSound,
      ledColor: Color(NotificationConfig.notificationColor),
      ledOnMs: NotificationConfig.ledOnMs,
      ledOffMs: NotificationConfig.ledOffMs,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      icon: NotificationConfig.defaultIcon,
      styleInformation: BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: senderName ?? "",
      ),
      // Actions cho notification
      actions: NotificationConfig.chatNotificationActions.map((action) => 
        AndroidNotificationAction(
          action['id']!,
          action['title']!,
          icon: DrawableResourceAndroidBitmap(action['icon']!),
          showsUserInterface: true,
        ),
      ).toList(),
      // Auto cancel sau khi tap
      autoCancel: NotificationConfig.autoCancel,
      // Ongoing notification (không thể swipe away)
      ongoing: NotificationConfig.ongoing,
      // Category cho Android
      category: AndroidNotificationCategory.message,
      // Group key để group các notification cùng loại
      groupKey: NotificationConfig.chatGroupKey,
      // Set as summary notification
      setAsGroupSummary: false,
      // Thêm timestamp
      when: DateTime.now().millisecondsSinceEpoch,
      // Thêm ticker text cho status bar
      ticker: '$title: $message',
      // Thêm channel action
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(10000),
        title,
        message,
        notificationDetails,
      );
      debugPrint("NotificationService: Notification đã được gửi thành công");
    } catch (e) {
      debugPrint("NotificationService: Lỗi khi gửi notification: $e");
      rethrow;
    }
  }

  // Hàm show notification cho lifecycle
  Future<void> showLifecycleNotification(String message) async {
    final androidDetails = AndroidNotificationDetails(
      NotificationConfig.lifecycleChannelId,
      NotificationConfig.lifecycleChannelName,
      channelDescription: NotificationConfig.lifecycleChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: NotificationConfig.enableVibration,
      enableLights: NotificationConfig.enableLights,
      playSound: NotificationConfig.playSound,
      ledColor: Color(NotificationConfig.notificationColor),
      ledOnMs: NotificationConfig.ledOnMs,
      ledOffMs: NotificationConfig.ledOffMs,
      // Hiển thị trên màn hình khóa
      visibility:NotificationVisibility.public,
      // Hiển thị trong status bar
      fullScreenIntent: true,
      // Custom icon
      icon: NotificationConfig.defaultIcon,
      // Style cho notification
      styleInformation: BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: 'Trạng thái ứng dụng',
        htmlFormatContentTitle: true,
      ),
      // Auto cancel sau khi tap
      autoCancel: NotificationConfig.autoCancel,
      // Ongoing notification (không thể swipe away)
      ongoing: NotificationConfig.ongoing,
      // Category cho Android
      category: AndroidNotificationCategory.message,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Trạng thái ứng dụng',
      message,
      notificationDetails,
    );
  }

  // Hàm show notification đơn giản (backward compatibility)
  Future<void> showNotification(String message) async {
    await showLifecycleNotification(message);
  }

  // Hàm cancel notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Hàm cancel tất cả notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Hàm get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }


  // Khởi tạo Firebase Cloud Messaging
  Future<void> _initializeFCM() async {
    try {
      // Xin quyền notification
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Lấy FCM token
        String? token = await _firebaseMessaging.getToken();
        debugPrint('FCM Token: $token');
        
        // Lưu token vào Firestore
        await _saveFCMTokenToFirestore(token);
        
        // Lắng nghe tin nhắn FCM
        _setupFCMListeners();
        
        // Lắng nghe khi token refresh
        _firebaseMessaging.onTokenRefresh.listen(_saveFCMTokenToFirestore);
      }
    } catch (e) {
      debugPrint('FCM Initialization error: $e');
    }
  }

  // Lưu FCM token vào Firestore
  Future<void> _saveFCMTokenToFirestore(String? token) async {
    if (token == null) return;
    
    try {
      final currentUserId = AppInit.instance.sharedPreferenceHelper.getIdUser;
      
      if (currentUserId != null) {
        await _firestore.collection('fcm_tokens').doc(currentUserId).set({
          'token': token,
          'updatedAt': FieldValue.serverTimestamp(),
          'platform': Platform.isAndroid ? 'android' : 'ios',
        });
      }
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  // Setup FCM message listeners
  void _setupFCMListeners() {
    // Xử lý tin nhắn khi app ở foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        showChatNotification(
          title: notification.title ?? 'Tin nhắn mới',
          message: notification.body ?? '',
          senderName: message.data['senderName'],
        );
      }
    });

    // Xử lý tin nhắn khi app ở background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM: App opened from background message');
    });

    // Xử lý tin nhắn khi app bị terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Lắng nghe tin nhắn mới từ conversations
  Future<void> _setupConversationListener() async {

    try {
      // Lắng nghe tất cả conversations
      _firestore.collection('conversations').snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.modified) {
            _handleConversationUpdate(change.doc);
          }
        }
      });
      debugPrint('Conversation listener setup completed');
    } catch (e) {
      debugPrint('Error setting up conversation listener: $e');
    }
  }

  // Xử lý khi có tin nhắn mới
  Future<void> _handleConversationUpdate(DocumentSnapshot doc) async {
    try {
      final me = _sharedPreferenceHelper.getIdUser;
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;

      final lastMessage = data['lastMessage'] as String?;
      final senderId = data['senderId'] as String?;
      final participantIds = List<String>.from(data['participantIds'] ?? []);
      final participants = data['participants'] as Map<String, dynamic>?;

      if (lastMessage == null || senderId == null || participantIds.isEmpty) return;

      // Bỏ qua nếu người gửi là chính mình
      if (me == senderId) return;

      // Lấy tên người gửi
      String senderName = 'Người dùng';
      if (participants != null && participants[senderId] != null) {
        final senderData = participants[senderId] as Map<String, dynamic>?;
        senderName = senderData?['name'] ?? 'Người dùng';
      }

      // Lấy danh sách người nhận (trừ người gửi)
      final recipients = participantIds.where((id) => id != senderId).toList();
      if (recipients.isEmpty) return;

      // Lấy FCM tokens của người nhận
      for (String recipientId in recipients) {
        await _sendNotificationToUser(
          recipientId: recipientId,
          senderName: senderName,
          message: lastMessage,
          conversationId: doc.id,
          senderId: senderId,
        );
      }
    } catch (e) {
      debugPrint('Error handling conversation update: $e');
    }
  }

  // Gửi thông báo cho một người dùng cụ thể
  Future<void> _sendNotificationToUser({
    required String recipientId,
    required String senderName,
    required String message,
    required String conversationId,
    required String senderId,
  }) async {
    try {
      // Lấy FCM token của người nhận
      final tokenDoc = await _firestore
          .collection('fcm_tokens')
          .doc(recipientId)
          .get();

      if (!tokenDoc.exists) {
        debugPrint('No FCM token found for user: $recipientId');
        return;
      }

      final tokenData = tokenDoc.data() as Map<String, dynamic>?;
      final fcmToken = tokenData?['token'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('Invalid FCM token for user: $recipientId');
        return;
      }

      // Gửi FCM notification
      await sendFCMNotification(
        recipientToken: fcmToken,
        title: senderName,
        body: message,
        data: {
          'conversationId': conversationId,
          'senderId': senderId,
          'type': 'chat_message',
        },
      );

      // Cũng hiển thị local notification
      await showChatNotification(
        title: senderName,
        message: message,
        senderName: senderName,
      );

      debugPrint('Notification sent to user: $recipientId');
    } catch (e) {
      debugPrint('Error sending notification to user $recipientId: $e');
    }
  }

  // Lấy FCM token hiện tại
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Gửi FCM notification sử dụng Server Key (đơn giản)
  Future<void> sendFCMNotification({
    required String recipientToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'to': recipientToken,
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
          'icon': 'ic_launcher',
          'color': '#16B978',
        },
        'data': data ?? {},
        'android': {
          'notification': {
            'channel_id': 'chat_messages',
            'priority': 'high',
            'visibility': 'public',
            'sound': 'default',
            'icon': 'ic_launcher',
            'color': '#16B978',
          }
        }
      };

      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('FCM sent successfully');
      } else {
        debugPrint('FCM send failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending FCM: $e');
    }
  }
}

// Background message handler (phải là top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM: Handling background message: ${message.messageId}');
  debugPrint('FCM: Message data: ${message.data}');
  
  // Xử lý notification khi app bị terminated
  // Có thể lưu message vào local storage để xử lý sau
}
