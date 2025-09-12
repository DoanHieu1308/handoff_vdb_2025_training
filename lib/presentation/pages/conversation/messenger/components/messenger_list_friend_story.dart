import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/messenger/messenger_store.dart';

import '../../../../../core/helper/app_custom_circle_avatar.dart';
import '../../../../../core/helper/app_text.dart';

class MessengerListFriendStory extends StatelessWidget {
  final MessengerStore messengerStore = AppInit.instance.messengerStore;
  MessengerListFriendStory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: double.infinity,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      children: [
                        AppCustomCircleAvatar(
                          image: messengerStore.conversationStore.profileStore.userProfile.avatar ?? ImagesPath.icPerson,
                          radius: 38,
                          height: 100,
                          width: 180,
                        ),
                        Transform.translate(
                          offset: Offset(57, 57),
                          child: false
                              ? Container(
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(Icons.add, size: 18),
                            ),
                          )
                              : Container(
                              height: 19,
                              width: 19,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2,),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Tin của bạn",
                    style: AppText.text11.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
