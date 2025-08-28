import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../../../core/helper/app_sitebox.dart';
import '../../../../../../../core/helper/app_text.dart';
import '../../../../../../../core/init/app_init.dart';


class CommentViewHeader extends StatelessWidget {
  final PostOutputModel itemPost;
  const CommentViewHeader({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    final postItemStore = AppInit.instance.postItemStore;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  itemPost.feels != null && itemPost.top2!.isNotEmpty
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: itemPost.top2![1] != "" ? 35 : 20,
                        child: Stack(
                          children: [
                            if(itemPost.top2![1] != "")
                              Positioned(
                                left: 15,
                                child: SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: SetUpAssetImage(
                                    postItemStore.feelNames[itemPost.top2![1]] ?? "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 17,
                              width: 17,
                              child: SetUpAssetImage(
                                postItemStore.feelNames[itemPost.top2![0]] ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSiteBox.w3,
                      Text("${itemPost.totalFeel}", style: AppText.text12),
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            ),
            Text("3 lượt chia sẻ", style: AppText.text14_bold),
          ],
        ),
        AppSiteBox.h15,
        Row(
          children: [
            Text("Tất cả bình luận", style: AppText.text14_bold),
            Icon(Icons.keyboard_arrow_down, size: 25),
          ],
        ),
      ],
    );
  }
}
