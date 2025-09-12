# Firestore Setup Guide

## Vấn đề hiện tại
Lỗi: `The database (default) does not exist for project handoffvdb2025`

## Giải pháp

### 1. Tạo Firestore Database
1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Chọn project `handoffvdb2025`
3. Vào **Firestore Database** trong menu bên trái
4. Click **Create database**
5. Chọn **Start in test mode** (tạm thời)
6. Chọn location gần nhất (ví dụ: `asia-southeast1`)

### 2. Deploy Firestore Rules
```bash
# Cài đặt Firebase CLI nếu chưa có
npm install -g firebase-tools

# Login vào Firebase
firebase login

# Deploy rules
firebase deploy --only firestore:rules
```

### 3. Cấu hình Firestore Rules
File `firestore.rules` đã được tạo với các quy tắc bảo mật phù hợp:
- Users chỉ có thể đọc/ghi dữ liệu của chính họ
- Conversations chỉ cho phép participants truy cập
- Messages được bảo vệ theo conversation

### 4. Test kết nối
Sau khi setup xong, chạy lại app để test:
```bash
flutter run
```

### 5. Cấu trúc Database
```
conversations/
  {conversationId}/
    participants: [userId1, userId2]
    createdAt: timestamp
    updatedAt: timestamp
    lastMessage: string
    lastMessageTime: timestamp
    isActive: boolean
    
    messages/
      {messageId}/
        senderId: string
        content: string
        type: string
        createdAt: timestamp
        status: string
        replyToMessageId?: string
        
    typing/
      {userId}/
        isTyping: boolean
        timestamp: timestamp

users/
  {userId}/
    name: string
    avatar?: string
    email?: string
    isOnline: boolean
    lastSeen: timestamp
    createdAt: timestamp
    updatedAt: timestamp
```

### 6. Troubleshooting
- Nếu vẫn lỗi, kiểm tra project ID trong `firebase_options.dart`
- Đảm bảo `google-services.json` được cập nhật
- Kiểm tra internet connection
- Restart app sau khi setup database
