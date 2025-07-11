import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/widget/build_snackbar.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/images_path.dart';
import '../../item_detail/item_detail_page.dart';

class ItemFriend extends StatefulWidget {
  final FriendsStore store;
  const ItemFriend({super.key, required this.store});

  @override
  State<ItemFriend> createState() => _ItemFriendState();
}

class _ItemFriendState extends State<ItemFriend> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.store.selectedCategoryName == ALL_FRIENDS) {
          return listItemFriend(
            onTap: (index){

            },
            friendList: widget.store.friendList,
            icon: ImagesPath.icMessenger,
            categoryName: ALL_FRIENDS,
            store: widget.store
          );
        }
        else if(widget.store.selectedCategoryName == SUGGESTIONS_FRIENDS){
          return listItemFriend(
              onTap: (index){

              },
              friendList: widget.store.friendList,
              icon: ImagesPath.icAddFriend,
              categoryName: SUGGESTIONS_FRIENDS,
              store: widget.store
          );
        }
        else if(widget.store.selectedCategoryName == FRIEND_REQUESTS){
          return listItemFriend(
              onTap: (index){
                print("index: ${widget.store.friendListRequests[index].id}");
                // Cập nhật trạng thái ngay lập tức để UI phản hồi
                final friendId = widget.store.friendListRequests[index].fromUser?.id;
                if (friendId != null) {
                  widget.store.markFriendAccepted(friendId);
                }
                
                widget.store.acceptFriendRequest(
                    requestId: widget.store.friendListRequests[index].id ?? '',
                    onSuccess: (){
                      ScaffoldMessenger.of(this.context).showSnackBar(
                          buildSnackBarNotify(
                              textNotify: "Accepted"
                          )
                      );
                    },
                    onError: (error){
                       // Nếu lỗi, revert lại trạng thái
                       if (friendId != null) {
                         widget.store.acceptedFriends.remove(friendId);
                       }
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                    }
                );
              },
              friendList: widget.store.friendListPending,
              icon: ImagesPath.icAlreadyFriends,
              categoryName: FRIEND_REQUESTS,
              store: widget.store
          );
        }
        else if(widget.store.selectedCategoryName == FOLLOWING){
          return listItemFriend(
              onTap: (index){

              },
              friendList: widget.store.friendList,
              icon: ImagesPath.icMessenger,
              categoryName: FOLLOWING,
              store: widget.store
          );
        }
        else {
          return const SizedBox();
        }
      },
    );
  }

  Widget listItemFriend({
    required List<UserModel> friendList,
    required String icon,
    required String categoryName,
    required FriendsStore store,
    required Function(int index) onTap
  }) {
    return Observer(builder: (_) =>
        ListView.builder(
          itemCount: friendList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Container(
                height: 70.h,
                width: 400.w,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 60.h,
                            width: 60.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              child: ClipOval(
                                  child: SetUpAssetImage(
                                    friendList[index].avatar ?? ImagesPath.icPerson,
                                    height: 60.h,
                                    width: 60.w,
                                    fit: BoxFit.contain,
                                  )
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                            width: 20.w,
                            child: Image.asset(
                              ImagesPath.imgVietNam,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.flag, size: 15.h);
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
                            Text(friendList[index].name ?? '', style: AppText.text14_Inter),
                            SizedBox(height: 5.h),
                            Text(
                              "8 mutual friends",
                              style: AppText.text12_Inter.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () => onTap(index),
                                child: SetUpAssetImage(
                                  height: 20.h,
                                  width: 20.w,
                                  widget.store.acceptedFriends[friendList[index].id] == true
                                      ? ImagesPath.icMessenger
                                      : icon,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.8,
                                      widthFactor: 1,
                                      child: ItemDetailPage(
                                          categoryName: categoryName,
                                          friendName: friendList[index].name,
                                          friendRequest: store.friendListRequests[index],
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
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.more_vert, size: 20.h);
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
            );
          },
        )
    );
  }
}

