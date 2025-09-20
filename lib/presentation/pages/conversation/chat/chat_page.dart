import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/components/chat_custom_show_media_gallery.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/components/chat_input_section.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../data/model/response/user_model.dart';
import 'components/chat_app_bar.dart';
import 'components/chat_message_list.dart';

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
        appBar: ChatAppBar(friend: widget.friend, chatStore: chatStore),
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
                child: ChatMessageList(chatStore: chatStore, widget: widget),
              ),
              SafeArea(
                child: ChatInputSection(chatStore: chatStore),
              ),
            ],
          ),
          Observer(
            builder: (context) {
              if (chatStore.showItemAction == ACTION_OPEN_GALLERY) {
                return ChatCustomShowMediaGallery();
              }
              return const SizedBox.shrink();
            },
          ),

          Observer(
            builder: (context) {
              if (chatStore.showItemAction == ACTION_OPEN_GALLERY &&
                  chatStore.listFile.isNotEmpty) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 55,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text("Chỉnh sửa", style: AppText.text14),
                      ),
                      AppSiteBox.w10,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 55,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          "Gửi",
                          style: AppText.text14.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

