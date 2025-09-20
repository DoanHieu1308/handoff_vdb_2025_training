import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel friend;
  final dynamic chatStore;

  const ChatAppBar({super.key, required this.friend, required this.chatStore});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.grey,
      backgroundColor: ColorResources.COLOR_F5F6F8,
      title: StreamBuilder<String>(
        stream: chatStore.firebasePresenceService.listenToUserPresence(friend.id ?? "",
        ),
        builder: (context, snapshot) {
          final state = snapshot.data ?? "offline";
          return Row(
            children: [
              Stack(
                children: [
                  AppCustomCircleAvatar(
                    image: friend.avatar ?? ImagesPath.icPerson,
                    radius: 20,
                    height: 40,
                    width: 40,
                  ),
                  Transform.translate(
                    offset: const Offset(28, 30),
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: const BoxDecoration(
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
                  Text(friend.name ?? "", style: AppText.text16_bold),
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
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
      ),
      actions: [
        AppTapAnimation(
          enabled: true,
          onTap: () {},
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
          onTap: () {},
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
