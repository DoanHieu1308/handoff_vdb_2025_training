import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:handoff_vdb_2025/presentation/widget/custom_dialog.dart';

import '../../../widget/build_snackbar.dart';
import '../../create_post/create_post_page.dart';
import '../post_item_store.dart';

class PostItemHeaderActions extends StatelessWidget {
  PostItemStore store = AppInit.instance.postStatusStore;
  final PostOutputModel itemPost;
  PostItemHeaderActions({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520.h,
      width: SizeUtil.getMaxWidth(),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 370,
            width: SizeUtil.getMaxWidth() - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
                children: [
                  buildItemSetting(
                    icon: ImagesPath.icPin,
                    describe: "Ghim bài viết",
                    onTap: (){

                    }
                  ),
                  buildItemSetting(
                      icon: ImagesPath.icSave,
                      describe: "Lưu bài viết",
                      onTap: (){

                      }
                  ),
                  if(itemPost.userId!.id == store.profileStore.userProfile.id)
                  buildItemSetting(
                      icon: ImagesPath.icBlackEdit,
                      describe: "Chỉnh sửa bài viết",
                      onTap: (){
                         router.pop();
                         showModalBottomSheet(
                             scrollControlDisabledMaxHeightRatio: 0.97,
                             context: context,
                             builder: (context) {
                               return CreatePostPage(initialPost: itemPost);
                             }
                         );
                      }
                  ),
                  buildItemSetting(
                      icon: ImagesPath.icLock,
                      describe: "Chỉnh sửa quyền riêng tư",
                      onTap: (){

                      }
                  ),
                  buildItemSetting(
                      icon: ImagesPath.icBoxSave,
                      describe: "Chuyển vào kho lưu trữ",
                      onTap: (){

                      }
                  ),
                  buildItemSetting(
                      icon: ImagesPath.icTurnOffNotification,
                      describe: "Tắt thông báo về bài viết này",
                      onTap: (){

                      }
                  ),
                  buildItemSetting(
                      icon: ImagesPath.icBlackCopyLink,
                      describe: "Sao chép liên kết",
                      onTap: (){
                      }
                  ),
                ]
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 110,
            width: SizeUtil.getMaxWidth() - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                buildItemSetting(
                    icon: ImagesPath.icDelete,
                    describe: "Xóa",
                    onTap: (){
                       showDialog(
                           context: context,
                           builder: (context) => CustomDialog(
                               title: "Xóa bài viết",
                               message: "Bạn có thể chỉnh sửa bài viết nếu cần thay đổi.",
                               textNumber1: "XÓA",
                               onTapNumber1: (){
                                 store.deletePost(
                                     postId: itemPost.id ?? "",
                                     onSuccess: (){
                                       router.pop();
                                       router.pop();
                                       store.profileStore.loadInitialPostsByUserId();
                                       ScaffoldMessenger.of(context).showSnackBar(
                                         buildSnackBarNotify(textNotify: "Xóa bài viết thành công"),
                                       );
                                     },
                                     onError: (error){
                                       ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(content: Text(error)));
                                     }
                                 );
                               },
                               textNumber2: "HỦY",
                               onTapNumber2: (){
                                 router.pop();
                               },
                           )
                       );
                    }
                ),
                buildItemSetting(
                    icon: ImagesPath.icHandshake,
                    describe: "Chia sẻ mã quảng cáo hợp tác",
                    onTap: (){

                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemSetting({
    required String icon,
    required String describe,
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: SizedBox(
          height: 45,
          child: Row(
            children: [
              SetUpAssetImage(icon, height: 28, width: 28),
              const SizedBox(width: 15),
              Text(describe, style: AppText.text14_Inter),
            ],
          ),
        ),
      ),
    );
  }
}
