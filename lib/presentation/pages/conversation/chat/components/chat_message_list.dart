import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../../data/model/chat/chat_message_model.dart';
import '../chat_page.dart';
import '../chat_store.dart';
import 'chat_bubble.dart' as chatbubble;
import 'chat_head_info_friend.dart';

class ChatMessageList extends StatelessWidget {
  final ChatStore chatStore;
  final ChatPage widget;

  const ChatMessageList({
    super.key,
    required this.chatStore,
    required this.widget,
  });


  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (chatStore.conversationId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (chatStore.errorMessage != null) {
          return Center(child: Text(chatStore.errorMessage!));
        }
        return Stack(
          children: [
            StreamBuilder<List<ChatMessageModel>>(
              stream: chatStore.firebaseChatService.streamMessagesRealtime(chatStore.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Lỗi: ${snapshot.error}"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData &&
                    snapshot.data!.isNotEmpty &&
                    snapshot.data!.first.id!.isNotEmpty &&
                    snapshot.data is QuerySnapshot &&
                    (snapshot.data as QuerySnapshot).metadata.hasPendingWrites) {
                  return const SizedBox.shrink();
                }

                chatStore.messages = snapshot.data ?? [];

                return ListView.builder(
                  key: ValueKey(chatStore.conversationId),
                  controller: chatStore.chatScrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: chatStore.messages!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == chatStore.messages!.length) {
                      return StreamBuilder<String>(
                        stream: chatStore.firebasePresenceService.listenToUserPresence(
                          widget.friend.id ?? "",
                        ),
                        builder: (context, snapPresence) {
                          final presenceState = snapPresence.data ?? "offline";
                          return ChatHeadInfoFriend(
                            avatar: widget.friend.avatar,
                            name: widget.friend.name,
                            state: presenceState,
                          );
                        },
                      );
                    }

                    final msg = chatStore.messages?[chatStore.messages!.length - 1 - index];
                    final prev = index < chatStore.messages!.length - 1
                        ? chatStore.messages![chatStore.messages!.length - index - 2]
                        : null;
                    final next = index > 0
                        ? chatStore.messages![chatStore.messages!.length - index]
                        : null;

                    final bool isFirst;
                    final bool isLast;

                    if (prev == null || prev.senderId != msg!.senderId) {
                      isFirst = true;
                    } else {
                      isFirst = false;
                    }

                    if (next == null || next.senderId != msg!.senderId) {
                      isLast = true;
                    } else {
                      isLast = false;
                    }

                    final now = DateTime.now();
                    final formatted = chatStore.formatLastMessageTime(
                      now,
                      msg!.createdAt,
                      prev: prev?.createdAt,
                    );

                    if (formatted != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(
                              formatted,
                              style: AppText.text12.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          chatbubble.ChatBubble(
                            chatMessage: msg,
                            isMe: msg.senderId == chatStore.profileStore.userProfile.id,
                            isFirst: isFirst,
                            isLast: isLast,
                          ),
                        ],
                      );
                    } else {
                      return chatbubble.ChatBubble(
                        chatMessage: msg,
                        isMe: msg.senderId == chatStore.profileStore.userProfile.id,
                        isFirst: isFirst,
                        isLast: isLast,
                      );
                    }
                  },
                );
              },
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: chatStore.showAutoscroll,
                  child: Positioned(
                    bottom: 20.w,
                    right: 16.w,
                    child: GestureDetector(
                      onTap: () {
                        chatStore.scrollToBottom();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ColorResources.COLOR_16B978,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: ColorResources.WHITE,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
