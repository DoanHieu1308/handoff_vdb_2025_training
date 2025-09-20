# Hướng dẫn thiết lập Notification System

## Tổng quan
Hệ thống notification đã được cải thiện để hiển thị thông báo ở cả màn hình khóa và status bar với các tính năng nâng cao.

## Các tính năng chính

### 1. Hiển thị trên màn hình khóa
- Thông báo sẽ hiển thị ngay cả khi màn hình bị khóa
- Sử dụng `NotificationVisibility.public` để đảm bảo hiển thị đầy đủ

### 2. Hiển thị trong status bar
- Thông báo xuất hiện trong status bar với priority cao
- Sử dụng `fullScreenIntent: true` để hiển thị trong status bar

### 3. Custom notification channels
- **Chat Messages**: Cho tin nhắn chat
- **Lifecycle**: Cho thông báo trạng thái app

### 4. Notification actions
- **Trả lời**: Cho phép trả lời nhanh từ notification
- **Đánh dấu đã đọc**: Đánh dấu tin nhắn đã đọc

## Cấu trúc files

### 1. `lib/core/helper/app_local_notification.dart`
- Service chính để quản lý notification
- Tạo notification channels
- Hiển thị các loại notification khác nhau

### 2. `lib/core/helper/notification_helper.dart`
- Helper class để quản lý notification logic
- Format nội dung tin nhắn
- Kiểm tra quyền và lifecycle

### 3. `lib/core/config/notification_config.dart`
- Cấu hình tất cả settings cho notification
- Màu sắc, âm thanh, rung động
- Icons và actions

## Cách sử dụng

### 1. Khởi tạo notification service
```dart
// Trong main.dart hoặc app_init.dart
await NotificationService().init();
```

### 2. Hiển thị notification cho tin nhắn chat
```dart
NotificationHelper().showChatMessageNotification(
  message: chatMessage,
  sender: senderUser,
  currentUser: currentUser,
);
```

### 3. Hiển thị notification lifecycle
```dart
NotificationService().showLifecycleNotification("App đã vào background");
```

## Cấu hình Android

### 1. Permissions trong AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
```

### 2. Icons
- `ic_reply.xml`: Icon cho action trả lời
- `ic_mark_read.xml`: Icon cho action đánh dấu đã đọc

## Tùy chỉnh

### 1. Thay đổi màu sắc
Trong `notification_config.dart`:
```dart
static const int notificationColor = 0xFF16B978; // Màu xanh lá
```

### 2. Thay đổi âm thanh và rung
```dart
static const bool enableVibration = true;
static const bool playSound = true;
```

### 3. Thay đổi hiển thị
```dart
static const bool showOnLockScreen = true;
static const bool showInStatusBar = true;
```

## Lưu ý quan trọng

1. **Quyền notification**: App cần xin quyền POST_NOTIFICATIONS trên Android 13+
2. **Notification channels**: Phải tạo channels trước khi hiển thị notification
3. **Lifecycle**: Notification chỉ hiển thị khi app không ở foreground
4. **Testing**: Test trên thiết bị thật để đảm bảo hoạt động đúng

## Troubleshooting

### 1. Notification không hiển thị
- Kiểm tra quyền POST_NOTIFICATIONS
- Kiểm tra notification channels đã được tạo
- Kiểm tra app có đang ở foreground không

### 2. Notification không hiển thị trên màn hình khóa
- Kiểm tra `NotificationVisibility.public`
- Kiểm tra quyền SYSTEM_ALERT_WINDOW
- Kiểm tra cài đặt notification của hệ thống

### 3. Actions không hoạt động
- Kiểm tra icons đã được thêm vào drawable
- Kiểm tra action IDs không trùng lặp
- Kiểm tra AndroidNotificationAction configuration