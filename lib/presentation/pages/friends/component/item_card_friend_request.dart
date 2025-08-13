import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/component/build_action_button.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/component/build_more_button.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/friend/friend_request_model.dart';
import '../../../widget/build_snackbar.dart';
import '../friends_store.dart';

class ItemCardFriendRequest extends StatelessWidget {
  final FriendsStore store;
  final FriendRequestModel friendRequest;

  const ItemCardFriendRequest({
    super.key,
    required this.store,
    required this.friendRequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => store.goToInfoFriend(context: context, friendId: friendRequest.fromUser?.id ?? ''),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: ClipOval(
                    child: SetUpAssetImage(
                      friendRequest.fromUser?.avatar ?? ImagesPath.icPerson,
                      fit: BoxFit.cover,
                      height: 60.h,
                      width: 60.w,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        friendRequest.fromUser?.name ?? '',
                        style: AppText.text14_Inter,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "3 mutual friends",
                        style: AppText.text12_Inter.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                  Observer(
                    builder: (_) =>
                    friendRequest.type == "accepted"
                        ? Padding(padding: EdgeInsets.only(right: 10.w),
                      child: Text("Accepted", style: AppText.text14_Inter,),)
                        : Row(
                      children: [
                        BuildActionButton(
                            onTap: (){
                              store.handleAcceptFriendRequest(friendId: friendRequest.fromUser?.id ?? "").then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildSnackBarNotify(
                                    textNotify: "Friend request accepted successfully!",
                                  ),
                                );
                              }).catchError((error) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));});
                            },
                            name: "Chấp nhận",
                        ),
                        SizedBox(width: 10.w),
                        BuildMoreButton(friend: friendRequest.fromUser!, categoryName: FRIEND_REQUESTS,),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}