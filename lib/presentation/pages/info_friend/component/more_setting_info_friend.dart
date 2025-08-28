import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_store.dart';

class MoreSettingInfoFriend extends StatelessWidget {
  InfoFriendStore store = AppInit.instance.infoFriendStore;
  MoreSettingInfoFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new, color: Colors.black)
        ),
      ),
      body: Container(
        width: SizeUtil.getMaxWidth(),
        height: SizeUtil.getMaxHeight(),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 10.h,
              width: SizeUtil.getMaxWidth(),
              color: ColorResources.LIGHT_GREY,
            ),
            buildItemMore(context),
            Container(
              height: 10.h,
              width: SizeUtil.getMaxWidth(),
              color: ColorResources.LIGHT_GREY,
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Liên kết đến trang cá nhân", style: AppText.text23_bold,),
                      Text("Liên kết riêng trên Facebook", style: AppText.text18.copyWith(color: Colors.grey),),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15.h),
                        height: 1.h,
                        width: SizeUtil.getMaxWidth(),
                        color: ColorResources.LIGHT_GREY,
                      ),
                      Text("https://www.facebook.com/doan.hieu", style: AppText.text14_bold,),
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.LIGHT_GREY.withOpacity(0.4)
                        ),
                        child: Center(
                          child: Text("Sao chép liên kết", style: AppText.text14_bold,),
                        ),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemMore(BuildContext context) {
    return Observer(
      builder: (context) {
        return Expanded(
          child: Column(
            children: [
              buildItemMoreInfo(
                  image: '',
                  name: store.profileFriend.isFollowing == true ? "Đã theo dõi" : "Theo dõi",
                  color: Colors.blue,
                  onTap: () {
                    print("FOLLOW STATUS: ${store.profileFriend.isFollowing}");
                    if(store.profileFriend.isFollowing == false){
                      store.handleFollowRequest(friendId: store.profileFriend.user?.id ?? '', context: context);
                    }else{
                      store.handleUnFollowRequest(friendId: store.profileFriend.user?.id ?? '', context: context);
                    }
                  },
                  textColor: store.profileFriend.isFollowing == true ? Colors.blue : Colors.black
              ),
              buildItemMoreInfo(image: ImagesPath.icReport, name: "Báo cáo trang cá nhân", color: Colors.black, onTap: () {}),
              buildItemMoreInfo(image: ImagesPath.icHelp, name: "Giúp", color: Colors.black, onTap: () {}),
              buildItemMoreInfo(image: ImagesPath.icBlock, name: "Chặn", color: ColorResources.LIGHT_GREY, onTap: () {}),
              buildItemMoreInfo(image: ImagesPath.icSearch, name: "Tìm kiếm", color: Colors.black, onTap: () {}),
              buildItemMoreInfo(image: ImagesPath.icInvite, name: "Mời bạn bè", color: Colors.black, onTap: () {}),
            ],
          ),
        );
      }
    );
  }

  Widget buildItemMoreInfo({
    required String image,
    required String name,
    Color? color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 53.h,
        width: 400.w,
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child:
                        image.isEmpty
                        ? Icon(
                          store.profileFriend.isFollowing == true ? Icons.visibility : Icons.visibility_off,
                          color: store.profileFriend.isFollowing == true ? Colors.blue : Colors.black,
                          size: 25,
                        )
                        : SetUpAssetImage(
                            image,
                            color: color,
                        ),
                  ),
                  SizedBox(width: 8.w),
                  Text(name, style: AppText.text16.copyWith(color: textColor)),
                ],
              ),
            ),
            Container(
              height: 1.h,
              width: SizeUtil.getMaxWidth(),
              color: ColorResources.LIGHT_GREY,
            ),
          ],
        ),
      ),
    );
  }
}
