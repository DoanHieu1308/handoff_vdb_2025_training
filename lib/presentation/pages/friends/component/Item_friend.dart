import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';

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
            number: 1,
            icFriend: ImagesPath.icMessenger,
            categoryName: ALL_FRIENDS
          );
        }
        else if(widget.store.selectedCategoryName == SUGGESTIONS_FRIENDS){
          return listItemFriend(
              number: 3,
              icFriend: ImagesPath.icAddFriend,
              categoryName: SUGGESTIONS_FRIENDS
          );
        }
        else if(widget.store.selectedCategoryName == FRIEND_REQUESTS){
          return listItemFriend(
              number: 5,
              icFriend: ImagesPath.icAlreadyFriends,
              categoryName: FRIEND_REQUESTS
          );
        }
        else if(widget.store.selectedCategoryName == FOLLOWING){
          return listItemFriend(
              number: 7,
              icFriend: ImagesPath.icMessenger,
              categoryName: FOLLOWING
          );
        }
        else {
          return const SizedBox();
        }
      },
    );
  }

  Widget listItemFriend({required int number, required String icFriend, required String categoryName}) {
    return ListView.builder(
      itemCount: number,
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
                                ImagesPath.icShareToGroup,
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
                        Text("Le Van An", style: AppText.text14_Inter),
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
                          child: SetUpAssetImage(
                            height: 20.h,
                            width: 20.w,
                            icFriend,
                            color: Colors.blue,
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
                                  child: ItemDetailPage(categoryName: categoryName,),
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
    );
  }
}

