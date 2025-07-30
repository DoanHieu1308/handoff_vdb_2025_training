import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';

import '../../../config/routes/route_path/auth_routers.dart';
import '../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/utils/color_resources.dart';
import '../../../core/utils/images_path.dart';
import '../../widget/item_folder_profile.dart';
import '../post_status/component/item_post_widget.dart';
import 'info_friend_store.dart';

class InfoFriendPage extends StatefulWidget {
  late InfoFriendStore store = AppInit.instance.infoFriendStore;

  InfoFriendPage({super.key});

  @override
  State<InfoFriendPage> createState() => _InfoFriendPageState();
}

class _InfoFriendPageState extends State<InfoFriendPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder:
          (_) => WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus();
              widget.store.isLSeeMore = false;
              return true;
            },
            child: Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 200.h, color: Colors.grey),
                          SizedBox(height: 50.h),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Text(
                              widget.store.profileFriend.user?.name ??
                                  "Tên bạn bè",
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
                                  style: AppText.text14.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          buildSentAndAcceptFriend(),
                          SizedBox(height: 15.h),
                          Container(
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: ColorResources.LIGHT_GREY,
                            ),
                          ),
                          buildCategoryFriendProfile(),
                          Container(
                            height: 1.h,
                            decoration: BoxDecoration(
                              color: ColorResources.LIGHT_GREY,
                            ),
                          ),
                          buildInfoFriendProfile(),
                          SizedBox(height: 10.h),
                          buildFeelingFriendProfile(),
                          SizedBox(height: 10.h),
                          buildPostFriendProfile(),
                          SizedBox(height: 10.h),
                        ],
                      ),
                      Positioned(
                        left: 10.w,
                        top: 75.h,
                        child: buildAvataFriendProfile(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  CircleAvatar buildAvataFriendProfile() {
    return CircleAvatar(
      radius: 90,
      backgroundColor: Colors.indigoAccent,
      child: ClipOval(
        child: SizedBox(
          width: 180,
          height: 180,
          child: SetUpAssetImage(
            widget.store.profileFriend.user?.avatar ?? ImagesPath.icPerson,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  SizedBox buildPostFriendProfile() {
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
                    radius: 30,
                    child: SetUpAssetImage(
                      height: 35.h,
                      width: 35.w,
                      ImagesPath.icPerson,
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
                        widget.store.profileFriend.user?.name ?? "Ten",
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
                ItemPostWidget(
                  width: 60,
                  name: "Thích",
                  image: ImagesPath.icLike,
                ),
                ItemPostWidget(
                  width: 70,
                  name: "Bình luận",
                  image: ImagesPath.icComment,
                ),
                ItemPostWidget(
                  width: 70,
                  name: "Nhắn tin",
                  image: ImagesPath.icMessenger,
                ),
                ItemPostWidget(
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

  Column buildFeelingFriendProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SizedBox(
            child: Text(
              "Bài viết của ${widget.store.profileFriend.user?.name ?? ''}",
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
                  radius: 30,
                  child: SetUpAssetImage(
                    height: 35.h,
                    width: 35.w,
                    ImagesPath.icPerson,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 20,
                child: Text(
                  "Viết gì đó cho ${widget.store.profileFriend.user?.name ?? ''}...",
                  style: AppText.text15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInfoFriendProfile() {
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
              widget.store.isLSeeMore = true;
            },
            child: Column(
              children: [
                Visibility(
                  visible: !widget.store.isLSeeMore,
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
                  visible: widget.store.isLSeeMore,
                  child: Text(
                    widget.store.profileFriend.user?.bio ?? "Giới thiệu",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildCategoryFriendProfile() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
      child: Row(
        children: [
          ItemFolderProfile(
            name: "Bài viết",
            onTap: () {
              widget.store.onChangedFolderIndexProfile(index: 0);
            },
            isSelected: widget.store.selectedFolderIndex == 0,
          ),
          ItemFolderProfile(
            name: "Giới thiệu",
            onTap: () {
              widget.store.onChangedFolderIndexProfile(index: 1);
            },
            isSelected: widget.store.selectedFolderIndex == 1,
          ),
          ItemFolderProfile(
            name: "Ảnh",
            onTap: () {
              widget.store.onChangedFolderIndexProfile(index: 2);
            },
            isSelected: widget.store.selectedFolderIndex == 2,
          ),
          ItemFolderProfile(
            name: "Video",
            onTap: () {
              widget.store.onChangedFolderIndexProfile(index: 3);
            },
            isSelected: widget.store.selectedFolderIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget buildSentAndAcceptFriend() {
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
                    if (widget.store.profileFriend.relation == STRANGER ) {
                      widget.store.friendsStore.handleSentFriendRequest(
                        friendId: widget.store.profileFriend.user?.id ?? '',
                        onSuccess: () {
                          widget.store.profileFriend = widget.store.profileFriend.copyWith(relation: PENDING_SENT);
                        },
                      );
                    } else if (widget.store.profileFriend.relation == PENDING_RECEIVED) {
                      widget.store.friendsStore.handleRejectFriendRequest(
                        friendId: widget.store.profileFriend.user?.id ?? '',
                        onSuccess: () {
                          widget.store.profileFriend = widget.store.profileFriend.copyWith(relation: STRANGER);
                          print( widget.store.profileFriend.relation);
                          },
                        context: context,
                        nameItemDetail: DENIED
                      );
                    }else if (widget.store.profileFriend.relation == PENDING_SENT) {
                      widget.store.friendsStore.handleCancelFriendRequest(
                          friendId: widget.store.profileFriend.user?.id ?? '',
                          onSuccess: () {
                            widget.store.profileFriend = widget.store.profileFriend.copyWith(relation: STRANGER);
                            print( widget.store.profileFriend.relation);
                          },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.h),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color:
                          widget.store.profileFriend.relation == ACCEPTED || widget.store.profileFriend.relation == PENDING_SENT || widget.store.profileFriend.relation == PENDING_RECEIVED
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
                          widget.store.profileFriend.relation == ACCEPTED
                              ? ImagesPath.icAlreadyFriends
                              : (widget.store.profileFriend.relation == PENDING_RECEIVED ? ImagesPath.icRejectFriend : ImagesPath.icAddFriend),
                          color:
                              widget.store.profileFriend.relation == ACCEPTED
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          widget.store.profileFriend.relation == ACCEPTED
                              ? "Bạn bè"
                              : (widget.store.profileFriend.relation == STRANGER
                                  ? "Thêm bạn bè"
                                  : (widget.store.profileFriend.relation == PENDING_SENT ? "Hủy yêu cầu" : "Từ chối")),
                          style: AppText.text14_Inter.copyWith(color: widget.store.profileFriend.relation == ACCEPTED || widget.store.profileFriend.relation == PENDING ? Colors.black : Colors.white,
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
                        widget.store.profileFriend.relation == ACCEPTED
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
                            widget.store.profileFriend.relation == ACCEPTED
                                ? Colors.white
                                : Colors.black,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Nhắn tin",
                        style: AppText.text14_Inter.copyWith(
                          color:
                              widget.store.profileFriend.relation == ACCEPTED
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
                    Navigator.of(
                      context,
                    ).pushNamed(AuthRouters.MORE_SETTING_INFO_FRIEND);
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
