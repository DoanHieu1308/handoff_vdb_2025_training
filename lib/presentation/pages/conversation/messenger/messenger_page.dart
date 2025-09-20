import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/messenger/messenger_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/chat_store.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/enums/message_content_type.dart';
import '../../../../core/enums/auth_enums.dart';
import 'components/messenger_item.dart';
import 'components/messenger_list_friend_story.dart';
import 'components/messenger_search_friend.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final MessengerStore messengerStore = AppInit.instance.messengerStore;
  final ChatStore chatStore = AppInit.instance.chatStore;
  late String _me = "";
  String? _lastProcessedMessageId; // Để tránh duplicate notification

  @override
  void initState() {
    super.initState();
    _me = messengerStore.sharedPreferenceHelper.getIdUser!;
  }

  // Helper method để convert message type
  MessageContentType _getMessageType(String? type) {
    switch (type) {
      case 'text':
        return MessageContentType.text;
      case 'image':
        return MessageContentType.image;
      case 'voice':
        return MessageContentType.voice;
      case 'video':
        return MessageContentType.video;
      case 'custom':
        return MessageContentType.custom;
      default:
        return MessageContentType.text;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        height: SizeUtil.getMaxHeight(),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSiteBox.h10,
              MessengerSearchFriend(),
              AppSiteBox.h15,
              MessengerListFriendStory(),
              buildConversationList(),
              buildFriendsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConversationList() {
    return Observer(
      builder: (context) {
        if (chatStore.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatStore.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Refresh conversations
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatStore.firebaseChatService.listenToConversations(_me),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Lỗi: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final conversations = snapshot.data ?? [];

            if (conversations.isEmpty) {
              return const Center(child: Text("Không có cuộc trò chuyện"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Cuộc trò chuyện gần đây',
                    style: AppText.text18_bold.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return _buildConversationItem(context, conversation, _me);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildFriendsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Bạn bè',
            style: AppText.text18_bold.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messengerStore.conversationStore.friendsStore.friendList.length,
          itemBuilder: (_, index) {
            final friend = messengerStore.conversationStore.friendsStore.friendList[index];
            return StreamBuilder<String>(
              stream: messengerStore.firebasePresenceService.listenToUserPresence(friend.id ?? ""),
              builder: (context, snapshot) {
                final state = snapshot.data ?? "offline";
                return MessengerItem(
                  friendId: friend.id ?? "",
                  avatar: friend.avatar ?? ImagesPath.icPerson,
                  friendName: friend.name ?? "",
                  friend: friend,
                  color: state == "online" ? Colors.green : Colors.grey,
                );
              }
            );
          }
        ),
      ],
    );
  }

  Widget _buildConversationItem(BuildContext context, Map<String, dynamic> conversation, String meId) {
    final participants = (conversation['participants'] as Map<String, dynamic>);
    final friends = participants.values
        .map((p) => UserModel.fromMap(Map<String, dynamic>.from(p)))
        .where((u) => u.id != meId)
        .toList();
    final lastMessageType = conversation['lastMessageType'];

    // Ví dụ: lấy friend đầu tiên (chat 1-1)
    final friend = friends.isNotEmpty ? friends.first : null;

    late String lastMessage;

    if (lastMessageType == "text") {
      lastMessage = conversation['lastMessage'];
    } else if (lastMessageType == "image") {
      lastMessage = "đã gửi một ảnh tin nhắn thoại";
    } else if (lastMessageType == "voice") {
      lastMessage = "đã gửi một tin nhắn thoại";
    } else if (lastMessageType == "custom") {
      lastMessage = "đã gửi một tin nhắn";
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 16, right: 8),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            router.push(
              AuthRoutes.CHAT,
              extra: friend,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AppCustomCircleAvatar(
                      image: friend?.avatar ?? ImagesPath.icPerson,
                      radius: 30,
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  friend?.name ?? 'Unknown',
                  style: AppText.text16_bold.copyWith(color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (conversation['lastMessage'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    lastMessage ,
                    style: AppText.text12.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (conversation['lastMessageTime'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(conversation['lastMessageTime']),
                    style: AppText.text10.copyWith(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format thời gian
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
