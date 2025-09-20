class NotificationConfig {
  // Cấu hình cho notification channels
  static const String chatChannelId = 'chat_messages';
  static const String chatChannelName = 'Tin nhắn Chat';
  static const String chatChannelDescription = 'Thông báo tin nhắn từ cuộc trò chuyện';
  
  static const String lifecycleChannelId = 'lifecycle_channel';
  static const String lifecycleChannelName = 'Lifecycle Notifications';
  static const String lifecycleChannelDescription = 'Thông báo khi app đổi trạng thái';
  
  // Cấu hình màu sắc và hiệu ứng
  static const int notificationColor = 0xFF16B978; // Màu xanh lá
  static const int ledOnMs = 1000;
  static const int ledOffMs = 500;
  
  // Cấu hình âm thanh và rung
  static const bool enableVibration = true;
  static const bool enableLights = true;
  static const bool playSound = true;
  static const bool showBadge = true;
  
  // Cấu hình hiển thị
  static const bool showOnLockScreen = true;
  static const bool showInStatusBar = true;
  static const bool autoCancel = true;
  static const bool ongoing = false;
  
  // Cấu hình group
  static const String chatGroupKey = 'chat_group';
  
  // Cấu hình icon
  static const String defaultIcon = '@mipmap/ic_launcher';
  static const String replyIcon = '@drawable/ic_reply';
  static const String markReadIcon = '@drawable/ic_mark_read';
  
  // Cấu hình timeout
  static const int notificationTimeoutMs = 5000; // 5 giây
  
  // Cấu hình số lượng notification tối đa
  static const int maxNotifications = 10;
  
  // Cấu hình cho các loại tin nhắn
  static const Map<String, String> messageTypeEmojis = {
    'image': '📷',
    'video': '🎥',
    'audio': '🎵',
    'file': '📎',
    'text': '',
  };
  
  // Cấu hình cho các action của notification
  static const List<Map<String, String>> chatNotificationActions = [
    {
      'id': 'reply',
      'title': 'Trả lời',
      'icon': '@drawable/ic_reply',
    },
    {
      'id': 'mark_read',
      'title': 'Đánh dấu đã đọc',
      'icon': '@drawable/ic_mark_read',
    },
  ];
  
  // Cấu hình cho notification khi app ở foreground
  static const bool showNotificationWhenAppInForeground = false;
  
  // Cấu hình cho notification khi có nhiều tin nhắn
  static const bool groupMultipleMessages = true;
  static const int maxSendersInGroupNotification = 3;
}
