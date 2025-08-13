import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_sent_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/component/build_action_button.dart';
import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/images_path.dart';
import '../../../widget/build_snackbar.dart';
import '../friends_store.dart';

class ItemCardFriendSent extends StatelessWidget {
  final FriendsStore store;
  final FriendSentModel friendRequest;

  const ItemCardFriendSent({
    super.key,
    required this.store,
    required this.friendRequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          store.goToInfoFriend(context: context,
              friendId: friendRequest.toUser?.id ?? ''),
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
                  radius: 30.h,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: ClipOval(
                    child: SizedBox(
                      height: 60.h,
                      width: 60.h,
                      child: SetUpAssetImage(
                        friendRequest.toUser?.avatar ?? ImagesPath.icPerson,
                        fit: BoxFit.cover,
                      ),
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
                        friendRequest.toUser?.name ?? '',
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
                  store.getStatusForFriend( friendRequest.toUser?.id ?? '') == "send"
                   ? Row(
                      children: [
                        BuildActionButton(
                          onTap: (){
                            store.handleCancelFriendRequest(
                                friendId: friendRequest.toUser?.id ?? '',
                                onSuccess: (){}
                            ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildSnackBarNotify(
                                textNotify: "Friend cancel accepted successfully!",
                              ),
                            );
                          }).catchError((error) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));});
                          },
                          name: "Hủy yêu cầu",
                          colorContainer: ColorResources.LIGHT_GREY,
                          colorText: Colors.black ),
                      ],)
                   : Padding(padding: EdgeInsets.only(right: 10.w),
                    child: Text("Canceled", style: AppText.text14_Inter,),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}