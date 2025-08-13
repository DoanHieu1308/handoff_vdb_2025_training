import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../info_friend_store.dart';

class InfoFriendProfile extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  InfoFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 10.h),
          child: Text("Chi tiết", style: AppText.text16_bold),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 10.h),
          child: Row(
            children: [
              Icon(Icons.home, color: Colors.grey),
              SizedBox(width: 10.w),
              Text("Sống tại ", style: AppText.text16),
              Text("Da Nang", style: AppText.text16_bold),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: GestureDetector(
            onTap: () {
              store.isLSeeMore = true;
            },
            child: Column(
              children: [
                Visibility(
                  visible: !store.isLSeeMore,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 30.w,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Center(
                            child: Text(
                              "...",
                              style: AppText.text16_bold.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Xem thong tin gioi thieu cua ban",
                        style: AppText.text16,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: store.isLSeeMore,
                  child: Text(
                    store.profileFriend.user?.bio ?? "Giới thiệu",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
