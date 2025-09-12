import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

import '../../../../../core/helper/app_custom_circle_avatar.dart';
import '../../../../../core/helper/app_tap_animation.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';

class MessengerItem extends StatelessWidget {
  final String avatar;
  final String friendId;
  final String friendName;
  final UserModel friend;
  final Color color;
  
  const MessengerItem({
    super.key,
    required this.avatar,
    required this.friendId,
    required this.friendName,
    required this.friend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppTapAnimation(
      enabled: true,
      onTap: (){
        // Truyền thông tin friend khi navigate
        router.push(
          AuthRoutes.CHAT,
          extra: friend,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: SizedBox(
          width: SizeUtil.getMaxWidth(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    AppCustomCircleAvatar(
                      image: avatar,
                      radius: 31,
                      height: 70,
                      width: 70,
                    ),
                    Transform.translate(
                      offset: Offset(46, 46),
                      child: Container(
                        height: 15,
                        width: 15,
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
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendName,
                      style: AppText.text16_bold.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Tap to start chatting",
                      style: AppText.text14.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
