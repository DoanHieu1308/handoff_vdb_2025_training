import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';
import '../info_friend_store.dart';

class FeelingFriendProfile extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  FeelingFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SizedBox(
            child: Text(
              "Bài viết của ${store.profileFriend.user?.name ?? ''}",
              style: AppText.text16_bold,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  child: ClipOval(
                    child: SizedBox(
                      height: 40.h,
                      width: 40.w,
                      child: SetUpAssetImage(
                        store.profileFriend.user!.avatar ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 20,
                child: Text(
                  "Viết gì đó cho ${store.profileFriend.user?.name ?? ''}...",
                  style: AppText.text15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
