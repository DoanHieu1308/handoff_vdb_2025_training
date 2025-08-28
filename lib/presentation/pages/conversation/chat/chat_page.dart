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
import 'package:hive/hive.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import 'components/chat_bubble.dart';
import 'components/write_chat.dart';

class ChatPage extends StatelessWidget {
  final chatStore = AppInit.instance.chatStore;

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorResources.COLOR_F5F6F8,
      appBar: AppBar(
        backgroundColor: ColorResources.COLOR_F5F6F8,
        title: Row(
          children: [
            Stack(
              children: [
                AppCustomCircleAvatar(
                  image: ImagesPath.icPerson,
                  radius: 20,
                  height: 40,
                  width: 40,
                ),
                Transform.translate(
                  offset: Offset(30, 30),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                    ),
                  ),
                )
              ],
            ),
            AppSiteBox.w10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thi Mai", style: AppText.text14_bold),
                Text(
                  "Hoạt động 18 phút trước",
                  style: AppText.text11.copyWith(
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
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
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SetUpAssetImage(
                height: 25,
                width: 25,
                ImagesPath.icCameraBlack,
                fit: BoxFit.cover,
                color: Colors.indigoAccent,
              ),
            ),
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                controller: chatStore.scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: chatStore.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatStore.messages[chatStore.messages.length - 1 - index];
                  final prev = index < chatStore.messages.length - 1
                          ? chatStore.messages[chatStore.messages.length - index - 2]
                          : null;
                  final next = index > 0
                          ? chatStore.messages[chatStore.messages.length - index]
                          : null;

                  final isFirst = prev == null || prev.isMe != msg.isMe;
                  final isLast = next == null || next.isMe != msg.isMe;

                  return ChatBubble(
                    text: msg.text,
                    isMe: msg.isMe,
                    isFirst: isFirst,
                    isLast: isLast,
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
          ),
        ),
        SafeArea(child: WriteChat(chatStore: chatStore)),
      ],
    );
  }
}
