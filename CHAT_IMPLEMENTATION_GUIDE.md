# Hướng dẫn triển khai hệ thống Chat với Firebase

## Tổng quan
Hệ thống chat đã được tích hợp hoàn chỉnh với Firebase Firestore, hỗ trợ real-time messaging, typing indicators, online status và nhiều tính năng khác.

## Các tính năng chính

### 1. Real-time Chat
- Gửi và nhận tin nhắn real-time
- Hỗ trợ nhiều loại tin nhắn: text, image, voice, file
- Trạng thái tin nhắn: pending, delivered, read
- Reply và reactions

### 2. Typing Indicators
- Hiển thị khi user đang gõ tin nhắn
- Real-time updates
- Tự động ẩn sau 5 giây

### 3. Online Status
- Hiển thị trạng thái online/offline của bạn bè
- Cập nhật real-time
- Last seen tracking

### 4. Conversation Management
- Tự động tạo conversation khi bắt đầu chat
- Lưu trữ lịch sử tin nhắn
- Tìm kiếm tin nhắn

## Cấu trúc Firebase

### Collections
```
users/
  {userId}/
    - name
    - avatar
    - isOnline
    - lastSeen

conversations/
  {conversationId}/
    - participants: [userId1, userId2]
    - lastMessage
    - lastMessageTime
    - createdAt
    - updatedAt
    
    messages/
      {messageId}/
        - senderId
        - content
        - type
        - createdAt
        - status
        - replyToMessageId
        
    typing/
      {userId}/
        - isTyping
        - timestamp

friendRequests/
  {requestId}/
    - fromUser
    - toUser
    - status
    - createdAt

friends/
  {friendId}/
    - fromUser
    - toUser
    - status
    - acceptedAt
```

## Cách sử dụng

### 1. Khởi tạo Chat
```dart
// Trong ChatPage
@override
void initState() {
  super.initState();
  _initializeChat();
}

Future<void> _initializeChat() async {
  if (widget.friend.id != null) {
    await chatStore.initializeChat(widget.friend.id!);
  }
}
```

### 2. Gửi tin nhắn
```dart
void _onSendTap(String message, ReplyMessage reply, MessageType messageType) async {
  await chatStore.sendMessage(
    content: message,
    type: _mapMessageType(messageType),
    replyToMessageId: reply.message.isNotEmpty ? reply.message : null,
  );
}
```

### 3. Typing Indicator
```dart
void _onTextChanged(String text) {
  if (text.isNotEmpty) {
    chatStore.sendTypingIndicator(true);
  } else {
    chatStore.sendTypingIndicator(false);
  }
}
```

### 4. Online Status
```dart
// Cập nhật khi vào app
chatStore.updateOnlineStatus(true);

// Cập nhật khi thoát app
chatStore.updateOnlineStatus(false);
```

## Cấu hình Firebase

### 1. Cài đặt dependencies
```yaml
dependencies:
  firebase_core: ^4.0.0
  firebase_auth: ^6.0.1
  cloud_firestore: ^6.0.0
```

### 2. Khởi tạo Firebase
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

### 3. Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

## Các file chính

### 1. FirebaseChatService
- `lib/data/services/firebase_chat_service.dart`
- Quản lý tất cả tương tác với Firebase
- Real-time listeners
- CRUD operations

### 2. ChatStore
- `lib/presentation/pages/conversation/chat/chat_store.dart`
- State management với MobX
- Tích hợp Firebase service
- Real-time updates

### 3. ChatPage
- `lib/presentation/pages/conversation/chat/chat_page.dart`
- UI chat với ChatView package
- Tích hợp với Firebase
- Typing indicators và online status

### 4. ConversationListPage
- `lib/presentation/pages/conversation/conversation_list/conversation_list_page.dart`
- Hiển thị danh sách conversations
- Real-time updates
- Navigation to chat

## Troubleshooting

### 1. Tin nhắn không hiển thị
- Kiểm tra Firebase connection
- Verify Firestore rules
- Check authentication status

### 2. Typing indicator không hoạt động
- Verify conversation ID
- Check typing collection permissions
- Monitor Firebase console logs

### 3. Online status không cập nhật
- Check user authentication
- Verify users collection permissions
- Monitor app lifecycle

## Performance Optimization

### 1. Pagination
- Implement message pagination cho conversations dài
- Lazy loading cho messages

### 2. Caching
- Cache user information locally
- Cache recent messages
- Offline support

### 3. Real-time Optimization
- Debounce typing indicators
- Batch message updates
- Connection state management

## Security Considerations

### 1. Authentication
- Tất cả operations yêu cầu authentication
- User chỉ có thể truy cập conversations của mình

### 2. Data Validation
- Validate message content
- Sanitize user input
- Rate limiting cho messages

### 3. Privacy
- Không expose user data không cần thiết
- Secure conversation access
- Message encryption (optional)

## Testing

### 1. Unit Tests
- Test Firebase service methods
- Test ChatStore logic
- Mock Firebase responses

### 2. Integration Tests
- Test real-time functionality
- Test authentication flow
- Test error handling

### 3. UI Tests
- Test chat interactions
- Test navigation
- Test responsive design

## Deployment

### 1. Firebase Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init

# Deploy
firebase deploy
```

### 2. Environment Configuration
- Configure Firebase project ID
- Set up authentication providers
- Configure Firestore indexes

### 3. Monitoring
- Enable Firebase Analytics
- Monitor Firestore usage
- Set up alerts for errors

## Kết luận

Hệ thống chat đã được tích hợp hoàn chỉnh với Firebase, cung cấp trải nghiệm chat real-time mượt mà với đầy đủ tính năng cần thiết. Đảm bảo tuân thủ các hướng dẫn bảo mật và performance để có trải nghiệm tốt nhất.
