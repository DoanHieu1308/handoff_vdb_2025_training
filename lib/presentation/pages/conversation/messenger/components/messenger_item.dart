import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';

import '../../../../../core/helper/app_custom_circle_avatar.dart';
import '../../../../../core/helper/app_sitebox.dart';
import '../../../../../core/helper/app_tap_animation.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';
import '../../../../../core/utils/images_path.dart';

class MessengerItem extends StatelessWidget {
  const MessengerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTapAnimation(
      enabled: true,
      onTap: (){
        router.push(AuthRoutes.CHAT);
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
                      image: ImagesPath.icPerson,
                      radius: 32,
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
                                  color: Colors.green
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              AppSiteBox.w10,
              Transform.translate(
                offset: Offset(0, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Thi Mai", style: AppText.text14_Inter,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Bạn: Đi chơi thôi", style: AppText.text13,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Transform.translate(
                              offset: Offset(0, -5),
                              child: Text(".", style: AppText.text20_bold)
                          ),
                        ),
                        Text("10:01", style: AppText.text13)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
