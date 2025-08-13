import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';

import '../../posts/components/custom_components/custom_icon_interact_post.dart';
import '../info_friend_store.dart';

class PostFriendProfile extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  PostFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(height: 3.h, color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    child: ClipOval(
                      child: SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: SetUpAssetImage(
                          store.profileFriend.user?.avatar ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  flex: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.profileFriend.user?.name ?? "Ten",
                        style: AppText.text16_bold,
                      ),
                      Row(
                        children: [
                          Text("12 giờ", style: AppText.text12),
                          SizedBox(
                            height: 30.h,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 7.h),
                              child: Center(
                                child: Text(" . ", style: AppText.text14),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock,
                            color: Colors.black.withOpacity(0.5),
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 18.h),
                      child: Center(
                        child: Text(
                          "...",
                          style: AppText.text25_bold.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(height: 300.h, color: Colors.green),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: 55.h,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconInteractPost(
                  width: 60,
                  name: "Thích",
                  image: ImagesPath.icLike,
                ),
                CustomIconInteractPost(
                  width: 70,
                  name: "Bình luận",
                  image: ImagesPath.icComment,
                ),
                CustomIconInteractPost(
                  width: 70,
                  name: "Nhắn tin",
                  image: ImagesPath.icMessenger,
                ),
                CustomIconInteractPost(
                  width: 70,
                  name: "Chia sẽ",
                  image: ImagesPath.icShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
