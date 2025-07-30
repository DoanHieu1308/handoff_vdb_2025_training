import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/images_path.dart';
import '../../item_detail/item_detail_page.dart';
import '../../friends/friends_store.dart';

class ListItemFriendSearch extends StatelessWidget {
  final List<UserModel> friendList;
  final String icon;
  final String? numberFriend;
  final FriendsStore store;
  const ListItemFriendSearch({super.key,
    required this.friendList,
    required this.icon,
    this.numberFriend,
    required this.store,
  });
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Observer(
        builder:
            (_) => store.isLoading
            ? SizedBox(
              height: SizeUtil.getMaxHeight(),
              width: SizeUtil.getMaxWidth(),
                 child: Center(
                     child: CircularProgressIndicator(strokeWidth: 4),
                 ),
              )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                child: SizedBox(
                  height: 25.h,
                  child: Text(
                    numberFriend!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: friendList.isEmpty
                    ? Center(child: Text("No friends found"))
                    : ListView.builder(
                  itemCount: friendList.isEmpty ? 0 : friendList.length,
                  itemBuilder: (context, index) {
                    // Ensure index is within bounds
                    if (index >= friendList.length) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        store.goToInfoFriend(
                          context: context,
                          friendId: friendList[index].id ?? ''
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Container(
                          height: 70.h,
                          width: 400.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 60.h,
                                      width: 60.h,
                                      child: CircleAvatar(
                                        backgroundColor:
                                        Colors.grey.withOpacity(0.2,),
                                        child: ClipOval(
                                          child: SetUpAssetImage(
                                            friendList[index].avatar ?? ImagesPath.icPerson,
                                            height: 60.h,
                                            width: 60.w,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                      width: 20.w,
                                      child: Image.asset(
                                        ImagesPath.imgVietNam,
                                        errorBuilder: (context, error, stackTrace,) {
                                          return Icon(
                                            Icons.flag,
                                            size: 15.h,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(friendList[index].name ?? '', style: AppText.text14_Inter,),
                                      SizedBox(height: 5.h),
                                      Text("${store.friendListPending.length} mutual friends",
                                        style: AppText.text12_Inter.copyWith(fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50.w,
                                  child: Row(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {

                                          },
                                          child: SetUpAssetImage(
                                            height: 20.h,
                                            width: 20.w,
                                            icon,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context,) {
                                              return FractionallySizedBox(
                                                heightFactor: 0.8,
                                                widthFactor: 1,
                                                child: ItemDetailPage(
                                                  categoryName:ALL_FRIENDS,
                                                  friend: friendList[index],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          height: 20.h,
                                          width: 20.h,
                                          ImagesPath.ic3Dot,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace,) {
                                            return Icon(
                                              Icons.more_vert,
                                              size: 20.h,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
