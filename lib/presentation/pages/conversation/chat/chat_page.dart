import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/components/chat_custom_show_media_gallery.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/response/user_model.dart';
import 'components/chat_reply.dart';
import 'components/write_chat.dart';
import 'components/chat_bubble.dart' as chatbubble;

class ChatPage extends StatefulWidget {
  final UserModel friend;

  ChatPage({super.key, required this.friend});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatStore = AppInit.instance.chatStore;
  late String state;

  @override
  void initState() {
    super.initState();
    chatStore.initializeChat([widget.friend]);
    chatStore.listenHasInput();
    chatStore.requestMedia();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        chatStore.conversationId = "";
        chatStore.showItemAction = "";
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorResources.COLOR_F5F6F8,
        appBar: AppBar(
          shadowColor: Colors.grey,
          backgroundColor: ColorResources.COLOR_F5F6F8,
          title: StreamBuilder<String>(
            stream: chatStore.firebasePresenceService.listenToUserPresence(
              widget.friend.id ?? "",
            ),
            builder: (context, snapshot) {
              state = snapshot.data ?? "offline";
              return Row(
                children: [
                  Stack(
                    children: [
                      AppCustomCircleAvatar(
                        image: widget.friend.avatar ?? ImagesPath.icPerson,
                        radius: 20,
                        height: 40,
                        width: 40,
                      ),
                      Transform.translate(
                        offset: Offset(28, 30),
                        child: Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state == "online"
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSiteBox.w10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.friend.name ?? "",
                        style: AppText.text16_bold,
                      ),
                      Text(
                        state == "online" ? "Đang hoạt động" : "offline",
                        style: AppText.text11.copyWith(color: Colors.black38),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
              chatStore.conversationId = "";
              chatStore.showItemAction = "";
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
          actions: [
            AppTapAnimation(
              enabled: true,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: SetUpAssetImage(
                  height: 20,
                  width: 20,
                  ImagesPath.icPhone,
                  fit: BoxFit.cover,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
            AppTapAnimation(
              enabled: true,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: SetUpAssetImage(
                  height: 25,
                  width: 25,
                  ImagesPath.icCameraBlack,
                  fit: BoxFit.cover,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
          ],
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Observer(
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
                              return Center(child: Text("Lỗi: ${snapshot.error}"));
                            }

                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.hasData &&
                                snapshot.data!.isNotEmpty &&
                                snapshot.data!.first.id!.isNotEmpty &&
                                snapshot.data is QuerySnapshot &&
                                (snapshot.data as QuerySnapshot)
                                    .metadata
                                    .hasPendingWrites) {
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
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 180),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            AppCustomCircleAvatar(
                                              image: widget.friend.avatar ?? ImagesPath.icPerson,
                                              radius: 50,
                                              height: 100,
                                              width: 100,
                                            ),
                                            Transform.translate(
                                              offset: Offset(75, 75),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                      state == "online"
                                                              ? Colors.green
                                                              : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppSiteBox.h5,
                                        Text(
                                          widget.friend.name ?? "User",
                                          style: AppText.text25_bold,
                                        ),
                                        Text(
                                          "Sống tại Đà Nẵng",
                                          style: AppText.text12.copyWith(
                                            color: Colors.black45,
                                          ),
                                        ),
                                        AppSiteBox.h10,
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          width: 140,
                                          child: Center(
                                            child: Text(
                                              "Xem trang cá nhân",
                                              style: AppText.text11_bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          formatted,
                                          style: AppText.text12.copyWith(color: Colors.black45),
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
                ),
              ),
              SafeArea(
                child: Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        if(chatStore.replyMessage != null)
                        ChatReply(replyMessage: chatStore.replyMessage),
                        WriteChat(chatStore: chatStore),
                        if(chatStore.showItemAction == ACTION_MORE)
                        SizedBox(
                          height: 260,
                          width: SizeUtil.getMaxWidth(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: chatStore.listItemActionChat1.length,
                                  itemBuilder: (context, index) {
                                    final item = chatStore.listItemActionChat1[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: buildItemActionChat(
                                          image: item["image"],
                                          name: item["name"]
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: chatStore.listItemActionChat2.length,
                                  itemBuilder: (context, index) {
                                    final item2 = chatStore.listItemActionChat2[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: buildItemActionChat(
                                        image: item2["image"],
                                        name: item2["name"]
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(chatStore.showItemAction == ACTION_OPEN_GALLERY)
                        SizedBox(
                          height: 260,
                          width: SizeUtil.getMaxWidth(),
                        )
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
          Observer(
            builder: (context) {
              if(chatStore.showItemAction == ACTION_OPEN_GALLERY) {
                return ChatCustomShowMediaGallery();
              }
              return const SizedBox.shrink();
            }
          ),

          Observer(
            builder: (context) {
              if(chatStore.showItemAction == ACTION_OPEN_GALLERY && chatStore.listFile.isNotEmpty) {
                return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text("Chỉnh sửa", style: AppText.text14),
                    ),
                    AppSiteBox.w10,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text("Gửi", style: AppText.text14.copyWith(color: Colors.white)),
                    )
                  ],
                ),
              );
              }
              return const SizedBox.shrink();
            }
          ),
        ],
      ),
    );
  }

  Widget buildItemActionChat({required String image, required String name}) {
    return Column(
      children: [
        AppCustomCircleAvatar(
          image: image,
          radius: 33,
          height: 80,
          width: 80,
        ),
        SizedBox(
            width: 85,
            child: Center(child: Text(name, style: AppText.text12, textAlign: TextAlign.center))
        ),
      ],
    );
  }
}


