import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';

import '../../../../../core/helper/app_tap_animation.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';

class ChatReply extends StatelessWidget {
  final chatStore = AppInit.instance.chatStore;
  final ChatMessageModel? replyMessage;
  ChatReply({
    super.key,
    this.replyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
      width: SizeUtil.getMaxWidth(),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Trả lời chính mình", style: AppText.text11_bold),
              Text(replyMessage?.content ?? "", style: AppText.text12.copyWith(color: Colors.grey))
            ],
          ),
          Spacer(),
          AppTapAnimation(
              enabled: true,
              onTap: (){
                 chatStore.replyMessage = null;
              },
              child: Icon(Icons.cancel_sharp, size: 28,color: Colors.grey.shade600)
          ),
        ],
      ),
    );
  }
}