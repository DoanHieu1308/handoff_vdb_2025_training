import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';

import '../../../../../../../core/utils/images_path.dart';
import '../../../../../../widget/item_setting.dart';

class CommentButtonAction extends StatelessWidget {
  final String commentId;
  final PostItemStore postItemStore = AppInit.instance.postItemStore;
  CommentButtonAction({super.key, required this.commentId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: SizeUtil.getMaxWidth(),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        children: [
          AppSiteBox.h10,
          Container(
            width: SizeUtil.getMaxWidth() - 40,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Center(
              child: ItemSetting(
                  enabled: true,
                  icon: ImagesPath.icDelete,
                  describe: "Xóa",
                  onTap: (){
                     postItemStore.deleteComment(
                         commentId: commentId,
                         onSuccess: (){
                           context.pop();
                         },
                         onError: (error){
                           context.pop();
                         }
                     );
                  }
              ),
            ),
          ),
          AppSiteBox.h10,
          Container(
            width: SizeUtil.getMaxWidth() - 40,
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ItemSetting(
                    enabled: false,
                    icon: ImagesPath.icDelete,
                    describe: "Chia sẻ mã quảng cáo hợp tác",
                    onTap: (){

                    }
                ),
                ItemSetting(
                    enabled: false,
                    icon: ImagesPath.icDelete,
                    describe: "Chia sẻ mã quảng cáo hợp tác",
                    onTap: (){

                    }
                ),
                ItemSetting(
                    enabled: false,
                    icon: ImagesPath.icDelete,
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
}
