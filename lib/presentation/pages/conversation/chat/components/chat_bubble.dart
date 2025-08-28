import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';

import '../../../../../core/helper/app_text.dart';
import '../../../../../core/utils/color_resources.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isFirst;
  final bool isLast;
  final String? avatarUrl;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isFirst,
    required this.isLast,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isMe) {
      borderRadius = BorderRadius.only(
        topLeft: const Radius.circular(10),
        bottomLeft: const Radius.circular(10),
        topRight: isFirst ? const Radius.circular(10) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(10) : Radius.zero,
      );
    } else {
      borderRadius = BorderRadius.only(
        topRight: const Radius.circular(10),
        bottomRight: const Radius.circular(10),
        topLeft: isFirst ? const Radius.circular(10) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(10) : Radius.zero,
      );
    }

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.indigoAccent : ColorResources.WHITE,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        style: AppText.text14.copyWith(
          color: isMe ? ColorResources.WHITE : ColorResources.BLACK,
          fontWeight: FontWeight.w500
        ),
      ),
    );

    // Nếu là người nhận, hiển thị avatar ở tin nhắn cuối
    if (!isMe) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isLast)
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 2),
              child: AppCustomCircleAvatar(
                  image: ImagesPath.icPerson,
                  radius: 15,
                  height: 35,
                  width: 35
              ),
            )
          else const SizedBox(width: 28),
          Padding(
            padding: EdgeInsets.only(left: !isLast ? 8 : 0),
            child: bubble,
          ),
        ],
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: bubble,
      );
    }
  }
}
