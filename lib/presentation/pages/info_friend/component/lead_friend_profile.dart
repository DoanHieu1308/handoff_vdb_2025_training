import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';
import 'avatar_friend_profile.dart';

class LeadFriendProfile extends StatelessWidget {
  final store = AppInit.instance.infoFriendStore;
  LeadFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBackgroundBanner(),
                _buildAvatar(),
              ],
            ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                store.profileFriend.user?.name ?? "Tên bạn bè",
                style: AppText.text25_bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Row(
                children: [
                  Text("188", style: AppText.text16_bold),
                  SizedBox(width: 5.w),
                  Text(
                    "người bạn",
                    style: AppText.text14.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundBanner() {
    return Container(
      height: 220.h,
      width: SizeUtil.getMaxWidth(),
      color: Colors.transparent,
      child: SetUpAssetImage(ImagesPath.imgAnhNen, fit: BoxFit.cover),
    );
  }

  Widget _buildAvatar() {
    return Positioned(
      left: 10.w,
      bottom: -45.h,
      child: Hero(
          tag: store.profileFriend.user?.id ?? "",
          child: AvatarFriendProfile()
      ),
    );
  }
}
