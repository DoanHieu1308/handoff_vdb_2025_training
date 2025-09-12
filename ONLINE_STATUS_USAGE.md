# Hướng dẫn sử dụng Online Status với Firebase Auth

## Tổng quan

Hệ thống online status đã được tích hợp vào messenger để hiển thị trạng thái online/offline của users bằng cách bật tắt nút xanh dưới ảnh đại diện. **Sử dụng Firebase Authentication để bắt sự kiện online/offline realtime**.

## Cách hoạt động

### 1. Firebase Auth Integration
- **Khi user đăng nhập BE API**: Tự động tạo Firebase Auth user
- **Firebase Auth State Changes**: Lắng nghe sự kiện đăng nhập/đăng xuất
- **Real-time Presence**: Cập nhật online status realtime qua Firebase

### 2. Tự động hoạt động
- **Khi user đăng nhập**: Tự động set online
- **Khi app vào background**: Tự động set offline sau 5 phút
- **Khi app vào foreground**: Tự động set online
- **Khi user logout**: Tự động set offline

### 3. Hiển thị trong UI
- **Nút xanh**: User đang online
- **Nút xám**: User đang offline
- **Vị trí**: Dưới góc phải của avatar

## Các component đã được cập nhật

### 1. MessengerItem
- Hiển thị online status cho từng friend trong danh sách
- Sử dụng `SimpleOnlineStatus` widget

### 2. MessengerPage
- Hiển thị online status cho conversations gần đây
- Sử dụng `SimpleOnlineStatus` widget

### 3. SimpleOnlineStatus Widget
- Widget đơn giản để hiển thị online status
- Có thể tùy chỉnh màu sắc và kích thước

## Sử dụng SimpleOnlineStatus Widget

```dart
// Sử dụng cơ bản
SimpleOnlineStatus(
  userId: "user_id_here",
)

// Tùy chỉnh
SimpleOnlineStatus(
  userId: "user_id_here",
  size: 16,
  onlineColor: Colors.green,
  offlineColor: Colors.grey,
  borderColor: Colors.white,
  borderWidth: 2,
)
```

## Firebase Auth Integration

### 1. Tự động tạo Firebase Auth user
- Khi user đăng nhập BE API thành công
- Tự động tạo Firebase Auth user (email/password hoặc anonymous)
- Đảm bảo có thể bắt sự kiện auth state changes

### 2. Real-time Auth State Listening
- Lắng nghe `authStateChanges()` từ Firebase Auth
- Tự động khởi tạo presence tracking khi user sign in
- Tự động cleanup khi user sign out

### 3. Không ảnh hưởng đến BE API
- BE API vẫn hoạt động bình thường
- Firebase Auth chỉ dùng để bắt sự kiện online/offline
- Online status sẽ tự động cập nhật real-time

## Kết quả

Bây giờ trong màn hình messenger:
- ✅ Nút xanh dưới avatar = User online
- ✅ Nút xám dưới avatar = User offline
- ✅ Tự động cập nhật real-time
- ✅ Không cần refresh hay reload
