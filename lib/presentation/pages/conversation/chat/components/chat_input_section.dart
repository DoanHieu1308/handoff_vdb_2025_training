import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/chat_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/components/write_chat.dart';

import '../../../../../core/helper/app_custom_circle_avatar.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';
import '../../../../../core/utils/app_constants.dart';
import 'chat_reply.dart';

class ChatInputSection extends StatelessWidget {
  final ChatStore chatStore;
  const ChatInputSection({super.key, required this.chatStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            if (chatStore.replyMessage != null)
            ChatReply(replyMessage: chatStore.replyMessage),
            WriteChat(chatStore: chatStore),
            if (chatStore.showItemAction == ACTION_MORE)
              SizedBox(
                height: 260,
                width: SizeUtil.getMaxWidth(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        chatStore.listItemActionChat1.length,
                        itemBuilder: (context, index) {
                          final item =
                          chatStore.listItemActionChat1[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                            ),
                            child: buildItemActionChat(
                              image: item["image"],
                              name: item["name"],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
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
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                            ),
                            child: buildItemActionChat(
                              image: item2["image"],
                              name: item2["name"],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (chatStore.showItemAction == ACTION_OPEN_GALLERY)
              SizedBox(height: 260, width: SizeUtil.getMaxWidth()),
          ],
        );
      },
    );
  }

  Widget buildItemActionChat({required String image, required String name}) {
    return Column(
      children: [
        AppCustomCircleAvatar(image: image, radius: 33, height: 80, width: 80),
        SizedBox(
          width: 85,
          child: Center(
            child: Text(
              name,
              style: AppText.text12,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
