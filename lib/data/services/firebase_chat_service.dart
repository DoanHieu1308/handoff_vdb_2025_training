import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatview/chatview.dart';
import 'package:handoff_vdb_2025/core/enums/message_content_type.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferenceHelper _sharedPref = AppInit.instance.sharedPreferenceHelper;
  final ProfileStore profileStore = AppInit.instance.profileStore;
  String? get currentUserId => _sharedPref.getIdUser ?? "";

  /// Create or get conversation
  Future<String> createOrGetConversation(UserModel me, List<UserModel> friends) async {
    // Tạo map participants
    final participants = <String, dynamic>{};
    participants[me.id ?? ""] = me.toMap();
    for (var f in friends) {
      participants[f.id ?? ""] = f.toMap();
    }

    // Lấy danh sách userIds để check trùng
    final participantIds = participants.keys.toList()..sort();

    // Query xem đã có conversation nào có đúng participants chưa
    final query = await _firestore
        .collection("conversations")
        .where("participantIds", isEqualTo: participantIds)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    // Nếu chưa có -> tạo mới
    final newDoc = await _firestore.collection("conversations").add({
      'participants': participants,
      'participantIds': participantIds, // thêm field này để dễ query
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
      'senderId' : null,
      'lastMessageType': null,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'isActive': true,
    });

    return newDoc.id;
  }

  /// Stream để lắng nghe messages realtime - trả về chatview.Message list
  Stream<List<ChatMessageModel>> streamMessagesRealtime(
      String conversationId, {
        int limit = 50,
      }) {
    return _firestore
        .collection("conversations")
        .doc(conversationId)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return ChatMessageModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  /// Send message
  Future<String> sendMessage({
    required String conversationId,
    required String content,
    required MessageContentType type,
    CustomMessageSubType? subType,
    ChatMessageModel? replyMessage,
    String? localId,
    String? mediaUrl,
    String? mediaThumbnail,
    Duration? mediaDuration,
    String? fileName,
    int? fileSize,
    String? mimeType,
    Map<String, dynamic>? additionalData,
  }) async {
    final me = currentUserId;
    if (me == null) throw Exception('User not authenticated');

    final profile = profileStore.userProfile;
    final messagesRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');

    final payload = {
      'senderId': me,
      'senderName': profile.name,
      'senderAvatar': profile.avatar,
      'content': content,
      'type': type.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isEdited': false,
      'status': MessageStatus.pending.name,
      if (replyMessage != null) 'replyMessage': replyMessage.toMap(),
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (mediaThumbnail != null) 'mediaThumbnail': mediaThumbnail,
      if (mediaDuration != null) 'mediaDuration': mediaDuration.inMilliseconds,
      if (fileName != null) 'fileName': fileName,
      if (fileSize != null) 'fileSize': fileSize,
      if (mimeType != null) 'mimeType': mimeType,
      if (localId != null) 'localId': localId,
      'additionalData': {
        if (subType != null) 'subType': subType.name,
        ...?additionalData,
      },
    };

    final doc = await messagesRef.add(payload);

    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': content,
      'senderId' : me,
      'lastMessageType': type.name,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  /// Listen to conversations
  Stream<List<Map<String, dynamic>>> listenToConversations(String meId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: meId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .handleError((error) {
      print('Error in listenToConversations: $error');
      throw error;
    }).map((qs) => qs.docs.map((d) {
      final data = d.data();

      // Convert Timestamps → DateTime
      final converted = data.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate());
        }
        return MapEntry(key, value);
      });

      return {
        'id': d.id,
        ...converted,
      };
    }).toList());
  }

  /// Update message status
  Future<void> updateMessageStatus({
    required String conversationId,
    required String messageId,
    required MessageStatus status,
  }) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Mark message as read
  Future<void> markMessagesAsRead(String conversationId) async {
    final me = currentUserId;
    if (me == null) return;

    final qs = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('senderId', isNotEqualTo: me)
        .where('status', isNotEqualTo: MessageStatus.read.name)
        .get();

    final batch = _firestore.batch();
    for (final d in qs.docs) {
      batch.update(d.reference, {
        'status': MessageStatus.read.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  ///
  Future<void> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    final me = currentUserId;
    if (me == null) return;

    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('typing')
        .doc(me)
        .set({
      'isTyping': isTyping,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Listen to typing indication
  Stream<Map<String, bool>> listenToTypingIndicator(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('typing')
        .snapshots()
        .map((qs) {
      final now = DateTime.now();
      final out = <String, bool>{};
      for (final d in qs.docs) {
        final data = d.data();
        final ts = data['timestamp'] as Timestamp?;
        final fresh = ts != null && now.difference(ts.toDate()).inSeconds < 5;
        out[d.id] = (data['isTyping'] as bool? ?? false) && fresh;
      }
      return out;
    });
  }

  /// Delete message
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  }) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  /// Search messages realtime
  Stream<List<Message>> searchMessagesRealtime({
    required String conversationId,
    required String query,
  }) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('content')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(50)
        .snapshots()
        .map((qs) => qs.docs.map((d) {
      final data = d.data();

      // Convert Timestamp → DateTime
      final converted = data.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate());
        }
        return MapEntry(key, value);
      });

      return Message.fromJson(converted);

    }).toList());
  }


  Future<UserModel?> getUserInfo(String userId) async {
    try {
      final d = await _firestore.collection('users').doc(userId).get();
      if (!d.exists) return null;
      final data = d.data()!;
      return UserModel(
        id: d.id,
        name: data['name'] as String? ?? 'Unknown User',
        avatar: data['avatar'] as String?,
        email: data['email'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> createUserIfNotExists(UserModel user) async {
    final me = currentUserId;
    if (me == null) return;
    await _firestore.collection('users').doc(me).set({
      'name': user.name,
      'avatar': user.avatar,
      'email': user.email,
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
