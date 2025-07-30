import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/widget/build_action_button.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/response/user_model.dart';
import 'build_message_button.dart';
import 'build_more_button.dart';

class FriendItemCard extends StatelessWidget {
  final String categoryName;
  final UserModel friend;
  final FriendsStore store;

  const FriendItemCard({required this.friend, required this.categoryName, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => store.goToInfoFriend(context: context, friendId: friend.id ?? ''),
      child: Observer(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.h,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: ClipOval(
                        child: SetUpAssetImage(
                          friend.avatar ?? ImagesPath.icPerson,
                          height: 60.h,
                          width: 60.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(friend.name ?? "", style: AppText.text14_Inter),
                          SizedBox(height: 5.h),
                          Text("3 mutual friends", style: AppText.text12_Inter.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    if(categoryName == ALL_FRIENDS)
                      Row(
                        children: [
                          BuildMessageButton(),
                          SizedBox(width: 10.w),
                          BuildMoreButton(friend: friend, categoryName: ALL_FRIENDS,),
                        ],
                      )
                    else
                      store.getStatusForFriend(friend.id ?? '') != "send"
                      ? Row(
                        children: [
                          BuildActionButton(
                              onTap: (){
                                  store.handleSentFriendRequest(
                                      friendId: friend.id ?? '',
                                      onSuccess: (){}
                                  );
                              },
                              name: "Thêm bạn bè"
                          ),
                          SizedBox(width: 10.w),
                          // Text("${store.getStatusForFriend(friend.id ?? '')}"),
                          BuildMoreButton(friend: friend, categoryName: SUGGESTIONS_FRIENDS,),
                        ],
                      )
                      : Row(
                        children: [
                          BuildActionButton(
                              onTap: (){
                                store.handleCancelFriendRequest(
                                    friendId: friend.id ?? '',
                                    onSuccess: (){}
                                );
                              },
                              name: "Hủy yêu cầu",
                              widthSize: 33.w,
                              colorContainer: ColorResources.LIGHT_GREY,
                              colorText: Colors.black,
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}