# Firebase Presence Service Guide

## Tổng quan

Hệ thống Firebase Presence Service được thiết kế để quản lý trạng thái online/offline của users một cách real-time mà không ảnh hưởng đến BE API hiện tại. Service này hoạt động song song với BE API và chỉ sử dụng Firebase để theo dõi presence.

## Các thành phần chính

### 1. FirebasePresenceService
- **File**: `lib/data/services/firebase_presence_service.dart`
- **Chức năng**: Quản lý trạng thái online/offline với Firebase
- **Đặc điểm**: Hoạt động độc lập với BE API

### 2. AppLifecycleService
- **File**: `lib/data/services/app_lifecycle_service.dart`
- **Chức năng**: Tự động cập nhật online status dựa trên app lifecycle
- **Đặc điểm**: Tự động detect khi app vào foreground/background

### 3. OnlineStatusIndicator
- **File**: `lib/presentation/widget/online_status_indicator.dart`
- **Chức năng**: Widget hiển thị online status với real-time updates
- **Đặc điểm**: Sử dụng StreamBuilder để cập nhật real-time

## Cách hoạt động

### 1. Khởi tạo
```dart
// Tự động khởi tạo khi app khởi động
void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppInit.instance.init();
  
  // Khởi tạo App Lifecycle Service
  AppLifecycleService.instance.initialize();
  
  runApp(MyApp());
}
```

### 2. Khi user đăng nhập
```dart
// Tự động gọi trong LoginStore._saveLocalData()
await AppInit.instance.firebasePresenceService.onUserLogin();
```

### 3. Khi user logout
```dart
// Gọi method logout() trong LoginStore
await loginStore.logout();
```

### 4. App lifecycle events
- **Foreground**: Tự động set online
- **Background**: Tự động set offline sau 5 phút
- **Detached**: Cố gắng set offline trước khi app bị kill

## Sử dụng trong UI

### 1. Hiển thị online status đơn giản
```dart
OnlineStatusIndicator(
  userId: "user_id_here",
  size: 8,
)
```

### 2. Hiển thị online status với text
```dart
OnlineStatusIndicator(
  userId: "user_id_here",
  userName: "User Name",
  size: 8,
  showText: true,
  textStyle: TextStyle(fontSize: 14),
)
```

### 3. Custom colors
```dart
OnlineStatusIndicator(
  userId: "user_id_here",
  size: 8,
  onlineColor: Colors.green,
  offlineColor: Colors.red,
)
```

## API Methods

### FirebasePresenceService

#### Khởi tạo
```dart
await AppInit.instance.firebasePresenceService.initialize();
```

#### Cập nhật online status
```dart
await AppInit.instance.firebasePresenceService.setOnlineStatus(true);
```

#### Lắng nghe online status của user
```dart
Stream<bool> stream = AppInit.instance.firebasePresenceService
    .listenToUserOnlineStatus("user_id");
```

#### Lắng nghe online status của nhiều users
```dart
Stream<Map<String, bool>> stream = AppInit.instance.firebasePresenceService
    .listenToMultipleUsersOnlineStatus(["user1", "user2", "user3"]);
```

#### Lấy thông tin online status
```dart
Map<String, dynamic>? info = await AppInit.instance.firebasePresenceService
    .getUserOnlineInfo("user_id");
```

### AppLifecycleService

#### Force update online status
```dart
await AppLifecycleService.instance.forceUpdateOnlineStatus(true);
```

#### Reset background timer
```dart
AppLifecycleService.instance.resetBackgroundTimer();
```

## Cấu trúc Firebase

### Collection: `users`
```json
{
  "user_id": {
    "name": "User Name",
    "avatar": "avatar_url",
    "email": "user@email.com",
    "isOnline": true,
    "lastSeen": "timestamp",
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "source": "BE_API"
  }
}
```

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Conversations collection (cho chat)
    match /conversations/{conversationId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Tích hợp với Chat

### 1. Trong ChatStore
```dart
// Lắng nghe online status
void _listenToOnlineStatus(String userId) {
  _onlineStatusSubscription?.cancel();
  _onlineStatusSubscription = AppInit.instance.firebasePresenceService
      .listenToUserOnlineStatus(userId)
      .listen((isOnline) {
    onlineUsers[userId] = isOnline;
  });
}

// Cập nhật online status
Future<void> updateOnlineStatus(bool isOnline) async {
  await AppInit.instance.firebasePresenceService.setOnlineStatus(isOnline);
}
```

### 2. Trong ChatPage
```dart
// Sử dụng OnlineStatusIndicator
OnlineStatusIndicator(
  userId: widget.friend.id ?? "",
  size: 8,
)
```

## Troubleshooting

### 1. Online status không cập nhật
- Kiểm tra Firebase connection
- Verify Firestore rules
- Check user authentication

### 2. App crash khi vào background
- Kiểm tra dispose methods
- Verify timer cancellation
- Check error handling

### 3. Performance issues
- Sử dụng `listenToMultipleUsersOnlineStatus` thay vì nhiều `listenToUserOnlineStatus`
- Implement proper cleanup trong dispose
- Sử dụng debounce cho frequent updates

## Best Practices

### 1. Error Handling
```dart
try {
  await AppInit.instance.firebasePresenceService.setOnlineStatus(true);
} catch (e) {
  print('Error setting online status: $e');
  // Fallback logic
}
```

### 2. Resource Management
```dart
@override
void dispose() {
  // Cancel subscriptions
  _onlineStatusSubscription?.cancel();
  super.dispose();
}
```

### 3. User Experience
- Hiển thị loading state khi cần thiết
- Implement fallback UI khi Firebase không khả dụng
- Sử dụng debounce để tránh UI flickering

## Migration từ BE API

### 1. Giữ nguyên BE API
- Authentication vẫn sử dụng BE
- User data vẫn lấy từ BE
- Chat functionality vẫn hoạt động bình thường

### 2. Thêm Firebase Presence
- Chỉ sử dụng Firebase cho online status
- Không thay đổi BE API calls
- Không ảnh hưởng đến existing functionality

### 3. Gradual rollout
- Có thể enable/disable Firebase presence
- Fallback về offline status nếu Firebase lỗi
- Monitoring và logging để track performance

## Monitoring và Analytics

### 1. Logs
```dart
print('FirebasePresenceService: User online status updated: $isOnline');
print('AppLifecycleService: App entered foreground');
```

### 2. Error Tracking
```dart
try {
  // Firebase operations
} catch (e) {
  print('FirebasePresenceService: Error: $e');
  // Send to error tracking service
}
```

### 3. Performance Metrics
- Response time của Firebase operations
- Battery usage impact
- Network usage

## Kết luận

Firebase Presence Service cung cấp một giải pháp robust để quản lý online status mà không ảnh hưởng đến BE API hiện tại. Service này tự động xử lý app lifecycle và cung cấp real-time updates cho online status của users.
