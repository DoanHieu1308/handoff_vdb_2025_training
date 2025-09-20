import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/enums/message_content_type.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';
import 'package:vibration/vibration.dart';

import '../../../../../core/helper/app_text.dart';
import '../../../../../core/utils/color_resources.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessageModel chatMessage;
  final bool isMe;
  final bool isFirst;
  final bool isLast;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.isFirst,
    required this.isLast,
    required this.chatMessage,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin{
  final chatStore = AppInit.instance.chatStore;
  bool get isOnlyEmoji => widget.chatMessage.content!.isOnlyEmoji;
  MessageContentType get type => widget.chatMessage.type ?? MessageContentType.text;
  late final SlidableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);

    _controller.animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Vibration.vibrate(duration: 30);

        chatStore.replyMessage = widget.chatMessage;

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _controller.close();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isMe) {
      borderRadius = BorderRadius.only(
        topLeft: const Radius.circular(15),
        bottomLeft: const Radius.circular(15),
        topRight: widget.isFirst ? const Radius.circular(10) : Radius.zero,
        bottomRight: widget.isLast ? const Radius.circular(10) : Radius.zero,
      );
    } else {
      borderRadius = BorderRadius.only(
        topRight: const Radius.circular(15),
        bottomRight: const Radius.circular(15),
        topLeft: widget.isFirst ? const Radius.circular(10) : Radius.zero,
        bottomLeft: widget.isLast ? const Radius.circular(10) : Radius.zero,
      );
    }

    final bubble = Container(
      width: SizeUtil.getMaxWidth() - 100,
      alignment: widget.isMe ? Alignment.bottomRight : Alignment.centerLeft,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: SizeUtil.getMaxWidth() - 100,
        ),
        child: Column(
          crossAxisAlignment:  widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if(widget.chatMessage.replyMessage != null)
            Transform.translate(
              offset: Offset(0, 10),
              child: Column(
                crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: widget.isMe ? 10 : 0),
                    child: Row(
                      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        SetUpAssetImage(
                          ImagesPath.icReplyChat,
                          height: 15,
                          width: 15,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          widget.chatMessage.senderId != widget.chatMessage.replyMessage?.senderId
                              ? "Bạn đã trả lời ${widget.chatMessage.replyMessage?.senderName}"
                              : "Bạn đã trả lời chính mình", style: AppText.text11.copyWith(color: Colors.grey.shade400),)
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: widget.isMe ? 0 : 8, right: widget.isMe ? 8 : 0),
                    padding: EdgeInsets.only(bottom: 20, top: 5, right: 15, left: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      widget.chatMessage.replyMessage?.content ?? "",
                      style: AppText.text14.copyWith(
                        color: widget.isMe ? ColorResources.WHITE : ColorResources.BLACK,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isOnlyEmoji
                    ? null
                    : (widget.isMe ? Colors.indigoAccent : ColorResources.WHITE),
                borderRadius: borderRadius,
              ),
              child: Text(
                widget.chatMessage.content ?? "",
                style: AppText.text14.copyWith(
                  color: widget.isMe ? ColorResources.WHITE : ColorResources.BLACK,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );


    // Nếu là người nhận, hiển thị avatar ở tin nhắn cuối
    if (!widget.isMe) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.isLast)
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 2),
              child: AppCustomCircleAvatar(
                image: widget.chatMessage.senderAvatar ?? ImagesPath.icPerson,
                radius: 15,
                height: 35,
                width: 35,
              ),
            )
          else
          const SizedBox(width: 28),
          Padding(
            padding: EdgeInsets.only(left: !widget.isLast ? 8 : 0),
            child: Slidable(
              key: ValueKey(widget.chatMessage.id),
              controller: _controller,
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Slidable.of(context)?.close();
                    },
                    backgroundColor: Colors.transparent,
                    icon: Icons.shortcut,
                    foregroundColor: Colors.blueAccent,
                    autoClose: true,
                  ),
                ],
              ),
              child: bubble,
            ),
          ),
        ],
      );
    } else {
      return Slidable(
        key: ValueKey(widget.chatMessage.id),
        controller: _controller,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                Slidable.of(context)?.close();
              },
              backgroundColor: Colors.transparent,
              icon: Icons.shortcut,
              foregroundColor: Colors.blueAccent,
              autoClose: true,
            ),
          ],
        ),
        child: Align(
              alignment: Alignment.centerRight,
              child: bubble
          ),
      );
    }
  }
}
