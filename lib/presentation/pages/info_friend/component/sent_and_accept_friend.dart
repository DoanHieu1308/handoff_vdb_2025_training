import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/enums/auth_enums.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../info_friend_store.dart';

class SentAndAcceptFriend extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  SentAndAcceptFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: GestureDetector(
                  onTap: () {
                    if (store.profileFriend.relation == STRANGER ) {
                      store.friendsStore.handleSentFriendRequest(
                        friendId: store.profileFriend.user?.id ?? '',
                        onSuccess: () {
                          store.profileFriend = store.profileFriend.copyWith(relation: PENDING_SENT);
                        },
                      );
                    } else if (store.profileFriend.relation == PENDING_RECEIVED) {
                      store.friendsStore.handleRejectFriendRequest(
                          friendId: store.profileFriend.user?.id ?? '',
                          onSuccess: () {
                            store.profileFriend = store.profileFriend.copyWith(relation: STRANGER);
                            print( store.profileFriend.relation);
                          },
                          context: context,
                          nameItemDetail: DENIED
                      );
                    }else if (store.profileFriend.relation == PENDING_SENT) {
                      store.friendsStore.handleCancelFriendRequest(
                        friendId: store.profileFriend.user?.id ?? '',
                        onSuccess: () {
                          store.profileFriend = store.profileFriend.copyWith(relation: STRANGER);
                          print( store.profileFriend.relation);
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.h),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color:
                      store.profileFriend.relation == ACCEPTED || store.profileFriend.relation == PENDING_SENT || store.profileFriend.relation == PENDING_RECEIVED
                          ? ColorResources.LIGHT_GREY
                          : ColorResources.COLOR_0956D6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SetUpAssetImage(
                          height: 20.h,
                          width: 20.w,
                          store.profileFriend.relation == ACCEPTED
                              ? ImagesPath.icAlreadyFriends
                              : (store.profileFriend.relation == PENDING_RECEIVED ? ImagesPath.icRejectFriend : ImagesPath.icAddFriend),
                          color:
                          store.profileFriend.relation == ACCEPTED
                              ? Colors.black
                              : Colors.white,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          store.profileFriend.relation == ACCEPTED
                              ? "Bạn bè"
                              : (store.profileFriend.relation == STRANGER
                              ? "Thêm bạn bè"
                              : (store.profileFriend.relation == PENDING_SENT ? "Hủy yêu cầu" : "Từ chối")),
                          style: AppText.text14_Inter.copyWith(color: store.profileFriend.relation == ACCEPTED || store.profileFriend.relation == PENDING ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 8,
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color:
                    store.profileFriend.relation == ACCEPTED
                        ? ColorResources.COLOR_0956D6
                        : ColorResources.LIGHT_GREY,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SetUpAssetImage(
                        ImagesPath.icMessenger,
                        color:
                        store.profileFriend.relation == ACCEPTED
                            ? Colors.white
                            : Colors.black,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Nhắn tin",
                        style: AppText.text14_Inter.copyWith(
                          color: store.profileFriend.relation == ACCEPTED
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    context.push(AuthRoutes.MORE_SETTING_INFO_FRIEND);
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: ColorResources.LIGHT_GREY,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Center(
                        child: Text("...", style: AppText.text16_bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
